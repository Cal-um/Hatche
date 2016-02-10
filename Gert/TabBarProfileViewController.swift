//
//  TabBarProfileViewController.swift
//  Gert
//
//  Created by Calum Harris on 08/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class TabBarProfileViewController: UIViewController, UINavigationBarDelegate {
  
  override func viewWillAppear(animated: Bool) {
    
    tabBarController?.title = "Your Title"
  }

}
