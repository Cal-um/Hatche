//
//  Time.swift
//  Gert
//
//  Created by Calum Harris on 09/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import Foundation

struct Time {
  
  private func convertSecondsToDays(inputSeconds: Double) -> Double {
    
    let hours = inputSeconds / 60 / 60
    let days = hours / 24
    return days
  }
  
  
  func difference(date: NSDate) -> String {
    let todaysDate = NSDate()
    var calc: Double
    var final: String
    
    let timeDifferenceInSeconds = todaysDate.timeIntervalSinceDate(date)
    
    let interval = convertSecondsToDays(timeDifferenceInSeconds)
    
    if interval < 1 {
      final = "Egg"
    } else if interval <= 6 {
      calc = interval
      final = String(Int(calc)) + " Days old"
    } else if interval <= (30.33 * 6) {
      calc = interval / 7
      final = String(Int(calc)) + " Weeks old"
    } else if interval <= 365 {
      calc = interval / 30.33
      final = String(Int(calc)) + " Months"
    } else {
      calc = interval / 365
      final = String(Int(calc)) + " years"
    }
    return final
  }
}

  
    
  

