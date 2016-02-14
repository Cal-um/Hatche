//
//  TabBarPhotoViewController.swift
//  Gert
//
//  Created by Calum Harris on 13/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class TabBarPhotoViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  var imageStore = ImageStore!()
  
  @IBAction func addPicture (sender: UIBarButtonItem) {
   
    let imagePicker = UIImagePickerController()
    
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      imagePicker.sourceType = .Camera
    }
    else {
      imagePicker.sourceType = .PhotoLibrary
    }
    
    imagePicker.delegate = self
    presentViewController(imagePicker, animated: true, completion: nil)

  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo Info: [String : AnyObject]) {
    
    let image = info[UIImagePickerContollerOriginalImage] as! UIImage
    
    imageStore.setImage(image, forKey: )
    
    // imageView.image = image
    
    
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}