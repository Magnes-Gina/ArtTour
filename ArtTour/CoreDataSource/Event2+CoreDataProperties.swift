//
//  Event2+CoreDataProperties.swift
//  ArtTour
//
//  Created by yikeren on 29/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//
//

import Foundation
import CoreData


extension Event2 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event2> {
        return NSFetchRequest<Event2>(entityName: "Event2")
    }

    @NSManaged public var about: String?
    @NSManaged public var address: String?
    @NSManaged public var enddate: String?
    @NSManaged public var eventid: Int64
    @NSManaged public var imgurl: String?
    @NSManaged public var longtitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var link: String?
    @NSManaged public var location: String?
    @NSManaged public var startdate: String?
    @NSManaged public var eventname: String?

}
