//
//  CustomImageView.swift
//  Gert
//
//  Created by Calum Harris on 08/03/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//


import UIKit

class CustomImageView: UIImageView {
  
  

  override var bounds : CGRect {
    didSet {
      self.layoutIfNeeded()
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.makeItCircle()
  }
  
  func makeItCircle() {
    self.layer.masksToBounds = true
    self.layer.cornerRadius  = CGFloat(roundf(Float(self.frame.size.width/2.0)))
    
  }
  
}
