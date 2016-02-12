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
  
  @IBAction func dissmissWhenTapped(sender: AnyObject) {
    nameTextField.resignFirstResponder()
    speciesTextField.resignFirstResponder()
  }
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
      datePicker.date = profile.dob!
    }
    
  //MARK: INPUT ITEMS AND KEYBOARD
  

  
  
 
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField == nameTextField {
      speciesTextField.becomeFirstResponder()
    } else {
      speciesTextField.resignFirstResponder()
    }
    return true
  }
  
  }

  //MARK: Add Hatchling
  

  
  
  
  /*@IBAction func sendToCoreOnAdd(segue:UIStoryboardSegue) {
    
    
    navigationController?.popViewControllerAnimated(true)
    
    if profile == nil {
      if let name = nameTextField.text, species = speciesTextField.text, dob: NSDate = datePicker.date  {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        profile = NSEntityDescription.insertNewObjectForEntityForName("Profile", inManagedObjectContext: appDelegate.managedObjectContext) as! Profile
        profile?.name = name
        profile?.species = species
        profile?.dob = dob
        print(profile)
        
        do {
          try appDelegate.managedObjectContext.save()
        } catch {
          fatalError("Failure to save context: \(error)")
        }
        
      }else{
        print("error enter all info")
      }
      
    }
    
  }
  */
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    let oldTextName: NSString = nameTextField.text!
    let oldTextSpecies: NSString = speciesTextField.text!
    
    let newTextName: NSString = oldTextName.stringByReplacingCharactersInRange(range, withString: string)
    let newTextSpecies: NSString = oldTextSpecies.stringByReplacingCharactersInRange(range, withString: string)
    
    saveButton.enabled = ((newTextName.length > 0) || (newTextSpecies.length > 0))
    
    return true
  }
  
 
    
    
  
  
  @IBAction func enabledSaveButton(sender: AnyObject) {
    saveButton.enabled = true
    
    let savedDate = profile.dob
    let datePickerDate = datePicker.date
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    let comparasonOne = dateFormatter.stringFromDate(savedDate!)
    let comparasonTwo = dateFormatter.stringFromDate(datePickerDate)
    
    if comparasonOne == comparasonTwo {
      saveButton.enabled = false
    }
  }
  
  
  

}
