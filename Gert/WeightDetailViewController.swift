//
//  WeightDetailViewController.swift
//  Gert
//
//  Created by Calum Harris on 03/03/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData

class WeightDetailViewController: UITableViewController, UITextFieldDelegate {
  
  var managedObjectContext: NSManagedObjectContext!
  

  
  var selectedProfile: Profile!
  
  var weight: Weight!
  
  var editWeight: Bool!
  
  @IBOutlet weak var weightInput: UITextField!
  
  @IBOutlet weak var weighDate: UIDatePicker!
  
  @IBOutlet weak var saveButton: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if editWeight == false {
      navigationItem.title = "Add Weight Record"
    } else if editWeight == true {
      let weightText = weight.recodedWeight
      weightInput.text = String(weightText)
      weighDate.date = weight.wDate
      navigationItem.title = "Edit Weight Record"
    }
    
    
    
  }
  

  
  @IBAction func dissmissWhenTapped(sender: AnyObject) {
    weightInput.resignFirstResponder()
    }


  @IBAction func didAddNumber(sender: AnyObject) {
    if Double(weightInput.text!) > 0 {
      saveButton.enabled = true
    } else {
      saveButton.enabled = false
    }
  }
  
  
  @IBAction func tappedDatePicker(sender: AnyObject) {
    weightInput.resignFirstResponder()
    saveButton.enabled = true
      }
  
  @IBAction func saveWeight(sender: AnyObject) {
    
    if editWeight == true {
      
      if let wDate: NSDate = weighDate.date, recordedWeight = weightInput.text {
        
        let rWeight = Double(recordedWeight)
        weight.wDate = wDate
        weight.recodedWeight = rWeight!
        weight.wOwner = selectedProfile
        saveContext()
        navigationController?.popViewControllerAnimated(true)
        
      }}
      
      if editWeight == false {
        
        if let wDate: NSDate = weighDate.date, recordedWeight = weightInput.text {
      
          let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
          weight = NSEntityDescription.insertNewObjectForEntityForName("Weight", inManagedObjectContext: appDelegate.managedObjectContext) as! Weight
        
          let rWeight = Double(recordedWeight)
          weight.wDate = wDate
          weight.recodedWeight = rWeight!
          weight.wOwner = selectedProfile
            }
            do {
              try managedObjectContext.save()
              } catch {
                fatalError("Failure to save context: \(error)")
              }
              } else {
                print("error enter all info")
             }
      
    navigationController?.popViewControllerAnimated(true)
    print(selectedProfile.profileWeight)
      }
      


    func saveContext () {
      if managedObjectContext.hasChanges {
        do {
          try managedObjectContext.save()
        } catch {
          let nserror = error as NSError
          NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
          abort()
        }
      }
    }


  
}


