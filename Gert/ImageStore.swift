//
//  ImageStore.swift
//  Gert
//
//  Created by Calum Harris on 14/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
  
  let cache = NSCache()
  
  func setImage(image: UIImage, forKey key:String) {
    cache.setObject(image, forKey: key)
  }
  
  func imageForKey(key:String) -> UIImage? {
    return cache.objectForKey(key) as? UIImage
  }
  
  func deleteImageForKey(key:String) {
    cache.removeObjectForKey(key)
  }
}
