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

    override func viewDidLoad() {
        super.viewDidLoad()
      navigationController?.navigationBar.tintColor = UIColor.blueColor()//UIColor(red: 128, green: 183, blue: 182, alpha: 1)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
