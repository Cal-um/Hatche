//
//  Function.swift
//  Gert
//
//  Created by Calum Harris on 16/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import Foundation

let applicationDocumentsDirectory: String = {
  let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
  return paths[0]
 
}()

