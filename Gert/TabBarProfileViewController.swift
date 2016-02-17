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
  }
  
  var selectedProfile: Profile!
  var photos: Photos!
  var managedObjectContext: NSManagedObjectContext!
 

  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var species: UILabel!
  @IBOutlet weak var age: UILabel!
  
  

  //let store = photos.owner!

 
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let dest = segue.destinationViewController as? EditProfileViewController {
      dest.managedObjectContext = managedObjectContext
      dest.profile = selectedProfile
      }
    }
  
  
  

}
