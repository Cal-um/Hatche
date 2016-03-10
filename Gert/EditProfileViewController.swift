//
//  EditProfileViewController.swift
//  Gert
//
//  Created by Calum Harris on 11/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData

class EditProfileViewController: UITableViewController, UITextFieldDelegate,UIGestureRecognizerDelegate  {
  
  var managedObjectContext: NSManagedObjectContext!
  
  var profile: Profile!
  
  var genderSelected: String!
  

  
  @IBOutlet weak var gender: UISegmentedControl!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var speciesTextField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  @IBOutlet weak var damTextLabel: UILabel!
  @IBOutlet weak var sireTextLabel: UILabel!
  
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let mother = profile.mother {
      damTextLabel.text = mother.name
    } else {
      damTextLabel.text = "Unknown"
    }
    
    if let father = profile.father {
      sireTextLabel.text = father.name
    } else {
      sireTextLabel.text = "Unknown"
    }
    
    navigationItem.title = "Edit Profile"
    
    if let profile = profile {
      nameTextField.text = profile.name
      speciesTextField.text = profile.species
      datePicker.date = profile.dob
      gender.selectedSegmentIndex = setSegmentedControl(profile.sex!)
      

    }
  }
  
  override func viewWillDisappear(animated: Bool) {
    nameTextField.resignFirstResponder()
    speciesTextField.resignFirstResponder()
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: nil, action: nil)
  }
  
  @IBAction func dissmissWhenTapped(sender: AnyObject) {
    nameTextField.resignFirstResponder()
    speciesTextField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == nameTextField {
      speciesTextField.becomeFirstResponder()
    } else {
      speciesTextField.resignFirstResponder()
    }
    return true
  }

  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if textField == nameTextField {
      let oldTextName: NSString = nameTextField.text!
      let newTextName: NSString = oldTextName.stringByReplacingCharactersInRange(range, withString: string)
      saveButton.enabled = (newTextName.length > 0)
    } else if textField == speciesTextField {
      let oldTextSpecies: NSString = speciesTextField.text!
      let newTextSpecies: NSString = oldTextSpecies.stringByReplacingCharactersInRange(range, withString: string)
      saveButton.enabled = (newTextSpecies.length > 0)
    }
    return true
  }
  
  @IBAction func segmentedContolSelected(sender: AnyObject) {
   
    switch gender.selectedSegmentIndex {
    case 0:
      genderSelected = "Unsexed"
    case 1:
      genderSelected = "Male"
    case 2:
      genderSelected = "Female"
    default:
      break
    }
     saveButton.enabled = true
  }
  
  func setSegmentedControl(gender: String) -> Int {
    var holder: Int!
    switch gender {
    case "Unsexed":
      holder = 0
    case "Male":
      holder =  1
    case "Female":
      holder = 2
    default:
      break
    }
    return holder
  }
  
  
  
  
  
  @IBAction func enabledSaveButton(sender: AnyObject) {
    saveButton.enabled = true
    
    let savedDate = profile.dob
    let datePickerDate = datePicker.date
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let comparasonOne = dateFormatter.stringFromDate(savedDate)
    let comparasonTwo = dateFormatter.stringFromDate(datePickerDate)
    
    if comparasonOne == comparasonTwo {
      saveButton.enabled = false
    }
  }
  
  
  @IBAction func sendToCoreOnSave(segue:UIStoryboardSegue) {
    
    if nameTextField.text == nil {
      print("nameNil")
    }
    navigationController?.popViewControllerAnimated(true)
    
    if profile != nil {
      if let name = nameTextField.text, species = speciesTextField.text, dob: NSDate = datePicker.date {
        
        profile.name = name
        profile.species = species
        profile.dob = dob
        if genderSelected != nil {
        profile.sex = genderSelected
        }
        
        if managedObjectContext.hasChanges {
          do {
            try managedObjectContext.save()
            print("save Successful")
          } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
          }
        }
      } else {
        print("Its the damn sex")
      }
      }

    
   
  }
  

    

  @IBAction func deleteObject(sender: UIButton) {
    
    
    
    let title = "WARNING"
    let message = "This Action Will Delete Profile Permanently"
    let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    ac.addAction(cancelAction)
    
    let deleteProfile = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
      self.deleteSavedPhotos(self.profile)
      self.managedObjectContext.deleteObject(self.profile)
      
    
      
    
    
    self.dismissViewControllerAnimated(false, completion: nil)
  
    })
  
  
     ac.addAction(deleteProfile)
     presentViewController(ac, animated: true, completion: nil)
     
    
  }
  
  func deleteSavedPhotos(inputProfile: Profile) {
    if let photoIDArray = inputProfile.photo {
      let photosCast = photoIDArray.allObjects as! [Photos]
      for i in photosCast {
        i.removePhotoFile()
      }
    }
    if let _ = profile.profilePicID {
      profile.removePhotoFile()
    }
  }
  
  func exit(){
    self.dismissViewControllerAnimated(false, completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if (segue.identifier == "dam") {
      let destination = segue.destinationViewController as! LineageTableView
      destination.managedObjectContext = managedObjectContext
      destination.selectedProfile = profile
      destination.damTrueSireFalse = true
    }
    
    if (segue.identifier == "sire") {
      let destination = segue.destinationViewController as! LineageTableView
      destination.managedObjectContext = managedObjectContext
      destination.selectedProfile = profile
      destination.damTrueSireFalse = false
    }
  }
  
  

}
