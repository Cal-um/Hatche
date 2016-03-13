//
//  TabBarViewController.swift
//  Gert
//
//  Created by Calum Harris on 13/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData

class TabBarViewController: UITabBarController {
  
  var selectedProfile: Profile!
  var managedObjectContext: NSManagedObjectContext!
  var allProfiles: [Profile]!

}
