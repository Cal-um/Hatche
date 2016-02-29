//
//  Profile.swift
//  Gert
//
//  Created by Calum Harris on 16/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit
import CoreData


class Profile: NSManagedObject {

 
  var photoImage: UIImage? {
    return UIImage(contentsOfFile: photoPath)
  }
  
  //photoPath gives you the location of the photo
  
  var photoPath: String {
    //assert(photoID != nil, "No photo ID set")
    let filename = "Photo-\(profilePicID?.integerValue).jpeg"
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


}

