//
//  SavedLandmark+CoreDataProperties.swift
//  ArtTour
//
//  Created by yikeren on 26/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedLandmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedLandmark> {
        return NSFetchRequest<SavedLandmark>(entityName: "SavedLandmark")
    }

    @NSManaged public var category_id: Int16
    @NSManaged public var landmark_id: Int16
    @NSManaged public var landmark_latitude: Double
    @NSManaged public var landmark_longtitude: Double
    @NSManaged public var landmark_name: String?
    @NSManaged public var video: String?

}
