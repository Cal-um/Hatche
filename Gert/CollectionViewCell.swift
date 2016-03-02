//
//  CollectionViewCell.swift
//  Gert
//
//  Created by Calum Harris on 17/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  
  @IBOutlet weak var PhotoImageView: UIImageView!
  @IBOutlet weak var selectedImageMark: UIImageView!
  
  
  
  
  var sharing: Bool = false {
    didSet {
      selectedImageMark.hidden  = !sharing
    }
  }
  
  override var selected: Bool {
    didSet {
      if sharing {
        selectedImageMark.image = UIImage(named: selected ? "Tab-Bar-Profile_Click_25px" : "Tab-Bar-Profile_75px")
      }
    }
  }
  
  
  
  func changeToAspectFill() {
    self.PhotoImageView.contentMode = .ScaleAspectFill
  }

  func changeToAspectFit() {
    self.PhotoImageView.contentMode = .ScaleAspectFit
  }


}
