//
//  EditProfileViewController.swift
//  Gert
//
//  Created by Calum Harris on 11/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData

class EditProfileViewController: UITableViewController, UITextFieldDelegate {
  
  var managedObjectContext: NSManagedObjectContext!
  
  var profile: Profile!
  
 
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var speciesTextField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var cancelButton :UIButton!
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let profile = profile {
      nameTextField.text = profile.name
      speciesTextField.text = profile.species
      datePicker.date = profile.dob
    }
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
    
    
    navigationController?.popViewControllerAnimated(true)
    
    if profile != nil {
      if let name = nameTextField.text, species = speciesTextField.text, dob: NSDate = datePicker.date  {
        
        profile.name = name
        profile.species = species
        profile.dob = dob
        print(profile)
        
        do {
          try managedObjectContext.save()
        } catch {
          fatalError("Failure to save context: \(error)")
        }
      }else{
        print("error enter all info")
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
  }
  
  
  
  /*func fetchPhotos(into: Profile) -> [Photos] {
    var convert: [Photos]
    convert = into.photo!.allObjects as! [Photos]
    
    return convert
  }*/


}
