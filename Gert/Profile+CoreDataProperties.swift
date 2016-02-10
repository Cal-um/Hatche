//
//  Profile+CoreDataProperties.swift
//  Gert
//
//  Created by Calum Harris on 01/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Profile {

    @NSManaged var name: String
    @NSManaged var dob: NSDate?
    @NSManaged var species: String
    @NSManaged var profilePic: NSSet?

}
