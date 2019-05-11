//
//  LikeLandmark+CoreDataProperties.swift
//  ArtTour
//
//  Created by yikeren on 11/5/19.
//  Copyright © 2019 Monash University. All rights reserved.
//
//

import Foundation
import CoreData


extension LikeLandmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikeLandmark> {
        return NSFetchRequest<LikeLandmark>(entityName: "LikeLandmark")
    }

    @NSManaged public var category_id: Int16
    @NSManaged public var landmark_id: Int16
    @NSManaged public var landmark_latitude: Double
    @NSManaged public var landmark_longtitude: Double
    @NSManaged public var landmark_name: String?
    @NSManaged public var video: String?

}
