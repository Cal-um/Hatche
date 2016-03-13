//
//  Profile+CoreDataProperties.swift
//  Gert
//
//  Created by Calum Harris on 09/03/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Profile {

    @NSManaged var currentWeight: NSNumber?
    @NSManaged var dob: NSDate
    @NSManaged var name: String
    @NSManaged var notes: String?
    @NSManaged var profilePicID: NSNumber?
    @NSManaged var sex: String?
    @NSManaged var species: String
    @NSManaged var photo: NSSet?
    @NSManaged var profileWeight: NSSet?
    @NSManaged var mother: Profile?
    @NSManaged var father: Profile?
    @NSManaged var motherChild: NSSet?
    @NSManaged var fatherChild: NSSet?

}
