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
            Image(systemName: activity.category.icon)
                .foregroundColor(activity.category.color)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(.headline)
                
                Text(timeFormatter.string(from: activity.startTime) + " - " + timeFormatter.string(from: activity.endTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(activity.location.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}