//
//  Trip.swift
//  TravelPlanner
//
//  Created by Matt Berman on 6/16/25.
//


import Foundation
import SwiftData

@Model final class Trip {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String = ""
    var startDate: Date = Date.now
    var endDate: Date = Date.now
    var cities: [String] = Array<String>()
    @Relationship(deleteRule: .cascade) var activities: [Activity] = Array<Activity>()
    
    init(id: UUID = UUID(),
         title: String = "",
         startDate: Date = .now,
         endDate: Date = .now,
         cities: [String] = [],
         activities: [Activity] = []) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.cities = cities
        self.activities = activities
    }
}
