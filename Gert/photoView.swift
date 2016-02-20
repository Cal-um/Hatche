//
//  photoView.swift
//  Gert
//
//  Created by Calum Harris on 18/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class PhotoView: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  var selectPhoto: UIImage!
  
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
   imageView.image = selectPhoto
  }
  
  
}
