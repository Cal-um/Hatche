//
//  Photos+CoreDataProperties.swift
//  Gert
//
//  Created by Calum Harris on 16/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photos {

    @NSManaged var photoID: NSNumber
    @NSManaged var owner: Profile

}
