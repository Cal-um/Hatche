//
//  TabBarProfileViewController.swift
//  Gert
//
//  Created by Calum Harris on 08/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData

class TabBarProfileViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tbvc = self.tabBarController  as! TabBarViewController
    selectedProfile = tbvc.selectedProfile!
    managedObjectContext = tbvc.managedObjectContext!
    
    setProfilePicCircle()
    
    let backImage = UIImage(named: "entryViewIcon")
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style:  UIBarButtonItemStyle.Plain, target: self, action: "unwindToEntryTable")
    
  }
  
  var selectedProfile: Profile!
  var managedObjectContext: NSManagedObjectContext!
  var profilePicLoad: UIImage? {
    return selectedProfile.photoImage
  }


  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var species: UILabel!
  @IBOutlet weak var age: UILabel!
  @IBOutlet weak var profilePic: UIImageView!
 
  let defaultProfilePic = UIImage(named: "egg")
  
  
  override func viewWillAppear(animated: Bool) {
    
    
    if selectedProfile.photoImage != nil {
      profilePic.image = profilePicLoad
    } else {
      profilePic.image = defaultProfilePic
    }
    
    if let selectedProfile = selectedProfile {
      navigationItem.title = selectedProfile.name
      
      let ageCalc = Time()
      let ageCalcInput = selectedProfile.dob
      
      
      name.text = selectedProfile.name
      species.text = selectedProfile.species
      age.text = ageCalc.difference(ageCalcInput)
      
    } else {
      print("error in transfer")
    }
    
  }
  
  func setProfilePicCircle() {
    profilePic.layer.borderWidth = 1.0
    profilePic.layer.masksToBounds = false
    profilePic.layer.borderColor = UIColor.whiteColor().CGColor
    profilePic.layer.cornerRadius = 13
    profilePic.layer.cornerRadius = profilePic.frame.size.height/2
    profilePic.clipsToBounds = true
    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped"))
    profilePic.userInteractionEnabled = true
    profilePic.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func imageTapped() {
    
    let ac = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .ActionSheet)
    
    
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    ac.addAction(cancelAction)
    
    
    let addFromPhotoAlbum = UIAlertAction(title: "Choose From Album", style: .Default, handler:{_ in self.choosePhotoFromLibrary()})
    ac.addAction(addFromPhotoAlbum)
    
    if UIImagePickerController.isSourceTypeAvailable(.Camera) == true {
    let takePhoto = UIAlertAction(title: "Take Photo", style: .Default, handler: {_ in self.takePhotoWithCamera()})
    ac.addAction(takePhoto)
    }
    
    if selectedProfile.photoImage != nil   {
      let removePhoto = UIAlertAction(title: "Remove Profile Picture", style: .Destructive, handler: {_ in self.removeProfilePic()})
      ac.addAction(removePhoto)
    }
    
    presentViewController(ac, animated: true, completion: nil)
    
  }
  var image: UIImage?
  
  func saveProfilePhoto() {
    
    if let  _ =  image {
      
      
      selectedProfile.profilePicID = Photos.nextPhotoID()
      
      if let image = image {
        if let data = UIImageJPEGRepresentation(image, 0.5) {
          
          do {
            try data.writeToFile(selectedProfile.photoPath, options: .DataWritingAtomic)
          } catch {
            print("Error Writing File: \(error)")
          }
        
        
        
        
        do {
          try managedObjectContext.save()
          
        } catch {
          fatalError("Failure to save context: \(error)")
        }
      }else {
        print("error enter all info")
      }
    }
  }
  }

  
  func takePhotoWithCamera() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .Camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .PhotoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    presentViewController(imagePicker, animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    dismissViewControllerAnimated(true, completion: nil)
    
    image = info[UIImagePickerControllerEditedImage] as? UIImage
    saveProfilePhoto()
  }
  
  func removeProfilePic() {
    
      selectedProfile.removePhotoFile()
      profilePic.image = defaultProfilePic
      selectedProfile.profilePicID = nil
      saveContext()
      
  }
  
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let dest = segue.destinationViewController as? EditProfileViewController {
      dest.managedObjectContext = managedObjectContext
      dest.profile = selectedProfile
      }
    }
  
  func saveContext () {
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
  }

  func unwindToEntryTable(){
    self.performSegueWithIdentifier("unwindtoentry", sender: self)
  }
  
  
}
