//
//  ViewController.swift
//  Gert
//
//  Created by Calum Harris on 27/01/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData


class AddRepViewController: UITableViewController, UITextFieldDelegate {

  var managedObjectContext: NSManagedObjectContext!
  
  var profile: Profile!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    print(datePicker.date)
    
    
   
          
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  

  
  //MARK: INPUT ITEMS AND KEYBOARD
  
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var speciesTextField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  
  

  
  @IBAction func dissmissKeyboardWhenTableTapped(sender: AnyObject) {
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


  
  //MARK: Add Hatchling
  
  @IBOutlet var addGeckoButton: UIBarButtonItem!
  
 
  
  @IBAction func sendToCoreOnAdd(segue:UIStoryboardSegue) {
    

    navigationController?.popViewControllerAnimated(true) 
    
  if profile == nil {
    if let name = nameTextField.text, species = speciesTextField.text, dob: NSDate = datePicker.date  {
      
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        profile = NSEntityDescription.insertNewObjectForEntityForName("Profile", inManagedObjectContext: appDelegate.managedObjectContext) as! Profile
        profile?.name = name
        profile?.species = species
          profile?.dob = dob
          profile.photo = nil
          profile.profilePicID = nil 
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

  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    
    let nameButton: NSString = nameTextField.text!
    let speciesButton:NSString = speciesTextField.text!
    addGeckoButton.enabled = (speciesButton.length > 0) && (nameButton.length > 0)
    
    
    
    return true
  }

  
  
  
   override func viewWillDisappear(animated: Bool) {
    if addGeckoButton == true {
      print("meow")
    }
    }
}



