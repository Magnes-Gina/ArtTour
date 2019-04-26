//
//  Category+CoreDataProperties.swift
//  ArtTour
//
//  Created by yikeren on 26/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var category_id: Int16
    @NSManaged public var category_name: String?

}
