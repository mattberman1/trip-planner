import Foundation
import SwiftUI
import MapKit

/// Represents an activity in the trip planner.
struct Activity: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var startTime: Date
    var endTime: Date
    var location: Location
    var category: ActivityCategory
    var notes: String
    var isAllDay: Bool
    
    /// Validates that the end time is after the start time.
    var isValid: Bool {
        endTime > startTime
    }
    
    /// Duration of the activity in seconds.
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    /// Formatted duration string (e.g., "2h 30m")
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? ""
    }
    
    /// Initializes a new activity.
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - title: The title of the activity
    ///   - startTime: When the activity starts
    ///   - endTime: When the activity ends (must be after startTime)
    ///   - location: The location of the activity
    ///   - category: The category of the activity
    ///   - notes: Additional notes about the activity
    ///   - isAllDay: Whether the activity lasts all day
    init(
        id: UUID = UUID(),
        title: String,
        startTime: Date,
        endTime: Date,
        location: Location,
        category: ActivityCategory,
        notes: String = "",
        isAllDay: Bool = false
    ) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.location = location
        self.category = category
        self.notes = notes
        self.isAllDay = isAllDay
    }
}

/// Represents a geographic location with a name and coordinates.
struct Location: Codable, Hashable {
    var name: String
    var latitude: Double
    var longitude: Double
    
    /// The coordinate representation for MapKit
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Validates that the coordinates are within valid ranges.
    var isValid: Bool {
        (-90...90).contains(latitude) && (-180...180).contains(longitude)
    }
    
    /// Creates a location with the given parameters.
    /// - Parameters:
    ///   - name: The name of the location
    ///   - latitude: Latitude in degrees (-90 to 90)
    ///   - longitude: Longitude in degrees (-180 to 180)
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = max(-90, min(90, latitude))
        self.longitude = max(-180, min(180, longitude))
    }
}

/// Supported activity categories with associated icons and colors.
enum ActivityCategory: String, CaseIterable, Codable, Identifiable {
    case places = "Places"
    case tours = "Tours"
    case restaurant = "Restaurant"
    case bar = "Bar"
    case travel = "Travel"
    case hotel = "Hotel"
    
    var id: String { rawValue }
    
    /// SF Symbol name for the category icon.
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
    
    /// Default color for UI elements representing this category.
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
