import Foundation
import SwiftUI
import MapKit

/// A single itinerary item within a trip.
struct Activity: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var startTime: Date
    var endTime: Date
    var location: Location
    var category: ActivityCategory
    var notes: String = ""
    var isAllDay: Bool = false
}

/// A geographic point-of-interest associated with an activity.
struct Location: Codable, Hashable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

/// Supported activity categories and their SF‑Symbol icons.
enum ActivityCategory: String, CaseIterable, Codable {
    case places = "Places"
    case tours = "Tours"
    case restaurant = "Restaurant"
    case bar = "Bar"
    case travel = "Travel"
    case hotel = "Hotel"
    
    var icon: String {
        switch self {
        case .places:     return "mappin.circle.fill"
        case .tours:      return "binoculars.fill"
        case .restaurant: return "fork.knife"
        case .bar:        return "wineglass.fill"
        case .travel:     return "airplane"
        case .hotel:      return "bed.double.fill"
        }
    }
    
    /// A default color for UI swatches and map pins.
    var color: Color {
        switch self {
        case .places:     return .blue
        case .tours:      return .green
        case .restaurant: return .orange
        case .bar:        return .purple
        case .travel:     return .red
        case .hotel:      return .brown
        }
    }
}
