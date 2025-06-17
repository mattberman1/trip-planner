//
//  Activity.swift
//  TravelPlanner
//
//  Created by Matt Berman on 6/16/25.
//

import Foundation
import SwiftData

enum ActivityCategory: String, Codable, CaseIterable {
    case place, tour, restaurant, bar, travel, hotel
}

@Model final class Activity {
    @Attribute(.unique) var id: UUID = UUID()
    var tripID: UUID
    var title: String
    var date: Date
    var category: ActivityCategory
    var latitude: Double
    var longitude: Double

    init(tripID: UUID,
         title: String,
         date: Date,
         category: ActivityCategory,
         latitude: Double,
         longitude: Double) {
        self.tripID = tripID
        self.title = title
        self.date = date
        self.category = category
        self.latitude = latitude
        self.longitude = longitude
    }
}
