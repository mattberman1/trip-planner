//
//  ActivityRowView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//

import SwiftUI

struct ActivityRowView: View {
    let activity: Activity
    
    var body: some View {
        HStack {
            // Category icon with color
            Image(systemName: activity.category.icon)
                .foregroundColor(activity.category.color)
                .font(.title2)
                .frame(width: 32)
            
            // Activity details
            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(activity.title)
                    .font(.headline)
                    .lineLimit(1)
                
                // Time range
                if activity.isAllDay {
                    Text("All Day")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text(timeRangeString)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Location
                if !activity.location.name.isEmpty {
                    Text(activity.location.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Disclosure indicator
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    
    private var timeRangeString: String {
        let start = timeFormatter.string(from: activity.startTime)
        let end = timeFormatter.string(from: activity.endTime)
        return "\(start) - \(end)"
    }
    
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()

    private var timeFormatter: DateFormatter {
        Self.timeFormatter
    }
}

#Preview {
    let activity = Activity(
        title: "Visit Eiffel Tower",
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        location: Location(name: "Eiffel Tower", latitude: 48.8584, longitude: 2.2945),
        category: .places,
        notes: "Don't forget the camera!",
        isAllDay: false
    )
    
    return List {
        ActivityRowView(activity: activity)
    }
}