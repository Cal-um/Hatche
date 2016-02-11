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
  
  var selectedProfile: Profile?
  var managedObjectContext: NSManagedObjectContext!
  
  
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var species: UILabel!
  @IBOutlet weak var age: UILabel!
  
  
 
  

 
  override func viewWillAppear(animated: Bool) {
    
    
    if let selectedProfile = selectedProfile {
      navigationItem.title = selectedProfile.name
      
      let ageCalc = Time()
      let ageCalcInput = selectedProfile.dob
      
      name.text = selectedProfile.name
      species.text = selectedProfile.species
      age.text = ageCalc.difference(ageCalcInput!)
      
    } else {
      print("error in transfer")
    }
    
    
  }
  
  
  

}
