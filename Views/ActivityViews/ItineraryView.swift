//
//  ItineraryView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI

struct ItineraryView: View {
    @Binding var trip: Trip
    @Binding var showingNewActivity: Bool
    
    var body: some View {
        VStack {
            List {
                ForEach(groupedActivities.keys.sorted(), id: \.self) { date in
                    Section(header: Text(dateFormatter.string(from: date))) {
                        ForEach(groupedActivities[date] ?? []) { activity in
                            ActivityRowView(activity: activity)
                        }
                        .onDelete { indexSet in
                            deleteActivities(on: date, at: indexSet)
                        }
                    }
                }
            }
            
            Button(action: { showingNewActivity = true }) {
                Label("Add Activity", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    private var groupedActivities: [Date: [Activity]] {
        Dictionary(grouping: trip.activities) { activity in
            Calendar.current.startOfDay(for: activity.startTime)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    private func deleteActivities(on date: Date, at offsets: IndexSet) {
        let activitiesOnDate = groupedActivities[date] ?? []
        for index in offsets {
            if let activityIndex = trip.activities.firstIndex(where: { $0.id == activitiesOnDate[index].id }) {
                trip.activities.remove(at: activityIndex)
            }
        }
    }
}