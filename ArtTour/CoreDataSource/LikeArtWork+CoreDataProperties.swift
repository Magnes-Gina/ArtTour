//
//  LikeArtWork+CoreDataProperties.swift
//  ArtTour
//
//  Created by yikeren on 11/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//
//

import Foundation
import CoreData


extension LikeArtWork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikeArtWork> {
        return NSFetchRequest<LikeArtWork>(entityName: "LikeArtWork")
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
