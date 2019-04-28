//
//  Landmark2+CoreDataProperties.swift
//  ArtTour
//
//  Created by yikeren on 26/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//
//

import Foundation
import CoreData


extension Landmark2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Landmark2> {
        return NSFetchRequest<Landmark2>(entityName: "Landmark2")
    }

    @NSManaged public var landmark_id: Int16
    @NSManaged public var landmark_name: String?
    @NSManaged public var landmark_latitude: Double
    @NSManaged public var landmark_longtitude: Double
    @NSManaged public var category_id: Int16
    @NSManaged public var video: String?

}
