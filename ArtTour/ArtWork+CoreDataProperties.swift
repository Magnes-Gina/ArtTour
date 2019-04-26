//
//  ArtWork+CoreDataProperties.swift
//  ArtTour
//
//  Created by yikeren on 27/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//
//

import Foundation
import CoreData


extension ArtWork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArtWork> {
        return NSFetchRequest<ArtWork>(entityName: "ArtWork")
    }

    @NSManaged public var artist_id: Int16
    @NSManaged public var artwork_address: String?
    @NSManaged public var artwork_date: Int16
    @NSManaged public var artwork_description: String?
    @NSManaged public var artwork_id: Int16
    @NSManaged public var artwork_latitude: Double
    @NSManaged public var artwork_longtitude: Double
    @NSManaged public var artwork_name: String?
    @NSManaged public var artwork_structure: String?
    @NSManaged public var category_id: Int16

}
