//
//  TabBarProfileViewController.swift
//  Gert
//
//  Created by Calum Harris on 08/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData
import Social

class TabBarProfileViewController: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
  
  
  var selectedProfile: Profile!
  let defaultProfilePic = UIImage(named: "DefaultProfilePic")
  let parentDefaultPic = UIImage(named: "Default_picture_Square")
  var managedObjectContext: NSManagedObjectContext!
  var profilePicLoad: UIImage? {
    return selectedProfile.photoImage
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tbvc = self.tabBarController  as! TabBarViewController
    selectedProfile = tbvc.selectedProfile!
    managedObjectContext = tbvc.managedObjectContext!
    
    let backImage = UIImage(named: "entryViewIcon")
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style:  UIBarButtonItemStyle.Plain, target: self, action: #selector(TabBarProfileViewController.unwindToEntryTable))
    
    notes.delegate = self
    
    listenForBackgroundNotification()
    
  }

  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var species: UILabel!
  @IBOutlet weak var age: UILabel!
  @IBOutlet weak var profilePic: UIImageView!
  @IBOutlet weak var weight: UILabel!
  @IBOutlet weak var sex: UILabel!
  @IBOutlet weak var notes: UITextView!
  @IBOutlet weak var sireProfilePhoto: CustomImageView!
  @IBOutlet weak var damProfilePhoto: CustomImageView!
  @IBOutlet weak var sireNameLabel: UILabel!
  @IBOutlet weak var damNameLabel: UILabel!

  @IBOutlet weak var backgroundPhoto: UIImageView!

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
      sex.text = selectedProfile.sex
      
      if let father = selectedProfile.father {
        sireProfilePhoto.image = father.photoImage ?? parentDefaultPic
        sireNameLabel.text = father.name
      } else {
        sireProfilePhoto.image = parentDefaultPic
        sireNameLabel.text = "Unknown"
      }
      
      if let mother = selectedProfile.mother {
        damProfilePhoto.image = mother.photoImage ?? parentDefaultPic
        damNameLabel.text = mother.name
        } else {
        damProfilePhoto.image = parentDefaultPic
        damNameLabel.text = "Unknown"
      }
      
      if let savedNotes = selectedProfile.notes {
        notes.text = savedNotes
      }
   
      if let currentWeight = selectedProfile.currentWeight {
        let weightString = String(currentWeight)
        weight.text = "\(weightString)g"
      } else {
        weight.text = "N/A"
      }
      
    } else {
      print("error in transfer")
    }
    setProfilePicCircle()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarProfileViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarProfileViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

    
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    
    if notes.text != selectedProfile.notes {
      if notes.text == "" {
        selectedProfile.notes = nil
          
      } else {
      selectedProfile.notes = notes.text
      saveContext()
      }
    }
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  //TextView
  
  var kbHeight: CGFloat!
  
  @IBAction func textViewShouldReturn(sender: AnyObject) {
    notes.resignFirstResponder()
  }
  
  func keyboardWillShow(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        kbHeight = keyboardSize.height - CGRectGetHeight((tabBarController?.tabBar.frame)!)
        self.animateTextView(true)
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotificationCenter) {
    self.animateTextView(false)
  }
  
  func animateTextView(up: Bool) {
    let movement = (up ? -kbHeight : kbHeight)
    
    UIView.animateWithDuration(0.3, animations: {
      self.view.frame = CGRectOffset(self.view.frame, 0, movement)
    })
  }

  func setProfilePicCircle() {

    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TabBarProfileViewController.imageTapped))
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
    
    if let image = image {
  
      selectedProfile.profilePicID = Photos.nextPhotoID()
      
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
              } else {
                print("error enter all info")
              }
          }
      }

  func takePhotoWithCamera() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .Camera
    imagePicker.delegate = self
    imagePicker.allowsEditing = false
    presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func choosePhotoFromLibrary() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .PhotoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = false
    presentViewController(imagePicker, animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    dismissViewControllerAnimated(true, completion: nil)
    
    image = info[UIImagePickerControllerOriginalImage] as? UIImage
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
  
  func screenShotMethod()-> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
    view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
  
  
  
  func showAlertMessage(message: String!) {
    let alertController = UIAlertController(title: "Hatche", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  @IBAction func showShareOptions(sender: AnyObject) {
    
    let ac = UIAlertController(title: "", message: "Share Profile", preferredStyle: UIAlertControllerStyle.ActionSheet)

    let facebookPostAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
      
      if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
        let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookComposeVC.setInitialText(self.selectedProfile.name + " via Hatche for iPhone")
        facebookComposeVC.addImage(self.screenShotMethod())
        self.presentViewController(facebookComposeVC, animated: true, completion: nil)
        } else {
            self.showAlertMessage("Device not connected to a Facebook account")
          }
      }
    
    let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
    }
  
    ac.addAction(facebookPostAction)
    ac.addAction(dismissAction)
    presentViewController(ac, animated: true, completion: nil)
    }
  
  var observer: AnyObject!
  
  func listenForBackgroundNotification() {
    observer = NSNotificationCenter.defaultCenter().addObserverForName(
    UIApplicationDidEnterBackgroundNotification, object: nil,
    queue: NSOperationQueue.mainQueue()) { [weak self] _ in
    if let strongSelf = self {
      if strongSelf.presentedViewController != nil {
      strongSelf.dismissViewControllerAnimated(false, completion: nil)
      }
      strongSelf.notes.resignFirstResponder()
      }
    }
  }
  deinit {
      print("*** deinit \(self)")
      NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
}