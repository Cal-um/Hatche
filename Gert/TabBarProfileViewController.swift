//
//  TabBarProfileViewController.swift
//  Gert
//
//  Created by Calum Harris on 08/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData

class TabBarProfileViewController: UIViewController, UINavigationBarDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tbvc = self.tabBarController  as! TabBarViewController
    selectedProfile = tbvc.selectedProfile!
    managedObjectContext = tbvc.managedObjectContext!
    
    setProfilePicCircle()
   
    
    
  }
  
  var selectedProfile: Profile!
  var managedObjectContext: NSManagedObjectContext!
 

  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var species: UILabel!
  @IBOutlet weak var age: UILabel!
  @IBOutlet weak var profilePic: UIImageView!
  
  
  override func viewWillAppear(animated: Bool) {
    
    
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
    profilePic.layer.borderWidth=1.0
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
    
    if profile.profilePic
    let removePhoto = UIAlertAction(title: "Remove Profile Picture", style: .Destructive, handler: nil)
    ac.addAction(removePhoto)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    ac.addAction(cancelAction)
    
    if selectedProfile.photo!.count > 0 {
      let addFromPhotoAlbum = UIAlertAction(title: "Choose From Album", style: .Default, handler: nil)
      ac.addAction(addFromPhotoAlbum)
    }
    
    let takePhoto = UIAlertAction(title: "Take Photo", style: .Default, handler: nil)
    ac.addAction(takePhoto)
    
    presentViewController(ac, animated: true, completion: nil)
    
  }
  
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let dest = segue.destinationViewController as? EditProfileViewController {
      dest.managedObjectContext = managedObjectContext
      dest.profile = selectedProfile
      }
    }
  
}
