//
//  CustomCell.swift
//  Gert
//
//  Created by Calum Harris on 06/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var speciesLabel: UILabel!
  @IBOutlet weak var dohLabel: UILabel!
  @IBOutlet weak var profilePic: UIImageView!


  
  func setProfilePic() {
  profilePic.layer.borderWidth = 1.0
  profilePic.layer.masksToBounds = false
  profilePic.layer.borderColor = UIColor.whiteColor().CGColor
  profilePic.layer.cornerRadius = 13
  profilePic.layer.cornerRadius = profilePic.frame.size.height/2
  profilePic.clipsToBounds = true
  }
  
}
