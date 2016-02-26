//
//  Photos.swift
//  Gert
//
//  Created by Calum Harris on 15/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData


class Photos: NSManagedObject {
  
  
  //hasPhoto checks if the object contains a photo
  //var hasPhoto: Bool {
 //   return photoID != nil
//  }
  //returns the UIImage object by loading the image file.
  var photoImage: UIImage? {
    return UIImage(contentsOfFile: photoPath)
  }
  
  //photoPath gives you the location of the photo
  
  var photoPath: String {
    //assert(photoID != nil, "No photo ID set")
    let filename = "Photo-\(photoID.integerValue).jpeg"
    return (applicationDocumentsDirectory as NSString).stringByAppendingPathComponent(filename)
  }
  
  func removePhotoFile() {
      let path = photoPath
      let fileManager = NSFileManager.defaultManager()
      if fileManager.fileExistsAtPath(path) {
        do {
          try fileManager.removeItemAtPath(path)
        } catch {
          print("Error removing file: \(error)")
        }
      }
    }

  
  
  class func nextPhotoID() -> Int {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let currentID = userDefaults.integerForKey("photoID")
    userDefaults.setInteger((currentID + 1), forKey: "photoID")
    userDefaults.synchronize()
    return currentID
  }
  
}