//
//  Weight.swift
//  Gert
//
//  Created by Calum Harris on 02/03/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import Foundation
import CoreData


class Weight: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

  func setWeightArray(input: [Weight]) -> [Double] {
    var holder: [Double] = []
    for i in input {
      let convWeight = Double(round(1000 * Double((i.recodedWeight))) / 100)
      holder.append(convWeight)
    }
    return holder
  }
  
  func weighInDateArray(input: [Weight]) -> [String] {
    
    var holder: [String] = []
    let monthYearFormatter = NSDateFormatter()
    monthYearFormatter.dateFormat = "MMM, YY"
    for i in input {
      let dateString = monthYearFormatter.stringFromDate(i.wDate)
      holder.append(dateString)
    }
    return holder
  }
  
  
  
}
