//
//  Activity.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import Foundation
import CoreLocation
import SwiftUI

struct Activity: Identifiable, Codable {
    let id = UUID()
    var title: String
    var startTime: Date
    var endTime: Date
    var location: Location
    var category: ActivityCategory
    var notes: String = ""
}

struct Location: Codable {
    var name: String
    var latitude: Double
    var longitude: Double
}

enum ActivityCategory: String, CaseIterable, Codable {
    case places = "Places"
    case tours = "Tours"
    case restaurant = "Restaurant"
    case bar = "Bar"
    case travel = "Travel"
    case hotel = "Hotel"
    
    var icon: String {
        switch self {
        case .places: return "mappin.circle.fill"
        case .tours: return "binoculars.fill"
        case .restaurant: return "fork.knife"
        case .bar: return "wineglass.fill"
        case .travel: return "airplane"
        case .hotel: return "bed.double.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .places: return .blue
        case .tours: return .green
        case .restaurant: return .orange
        case .bar: return .purple
        case .travel: return .red
        case .hotel: return .brown
        }
    }
}