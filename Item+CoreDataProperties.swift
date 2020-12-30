//
//  Item+CoreDataProperties.swift
//  Todey
//
//  Created by 1389028 on 31/12/20.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var done: Bool
    @NSManaged public var title: String?
    @NSManaged public var parentCategory: Category?

}

extension Item : Identifiable {

}
