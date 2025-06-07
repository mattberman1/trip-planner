//
//  Trip.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import Foundation

struct Trip: Identifiable, Codable {
    let id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
    var cities: [String]
    var activities: [Activity] = []
}