//
//  Weight+CoreDataProperties.swift
//  Gert
//
//  Created by Calum Harris on 03/03/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Weight {

    @NSManaged var wDate: NSDate
    @NSManaged var recodedWeight: NSNumber
    @NSManaged var wOwner: Profile

}
