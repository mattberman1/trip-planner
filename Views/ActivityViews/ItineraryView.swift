//
//  ItineraryView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI

struct ItineraryView: View {
    private enum Constants {
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            return formatter
        }()
    }
    
    @Binding var trip: Trip
    @Binding var showingNewActivity: Bool
    @Binding var selectedActivity: Activity?
    
    @State private var cachedGroupedActivities: [Date: [Activity]] = [:]
    @State private var lastActivitiesCount = 0
    
    var body: some View {
        let _ = updateCacheIfNeeded()
        return VStack(spacing: 0) {
            // Trip Header
            VStack(alignment: .leading, spacing: 8) {
                Text(trip.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 16) {
                    Label(trip.startDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    Text("•")
                    Label(trip.endDate.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                if !trip.cities.isEmpty {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(trip.cities.joined(separator: ", "))
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Activities List
            List {
                let activitiesByDate = groupedActivities
                ForEach(activitiesByDate.keys.sorted(), id: \.self) { date in
                    Section(header: Text(Constants.dateFormatter.string(from: date))) {
                        let activities = activitiesByDate[date] ?? []
                        ForEach(activities, id: \.id) { activity in
                            Button(action: {
                                selectedActivity = activity
                            }) {
                                ActivityRowView(activity: activity)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .onDelete { indexSet in
                            deleteActivities(on: date, at: indexSet)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .padding(.top, 8)
            
            // Add Activity Button
            Button(action: { showingNewActivity = true }) {
                Label("Add Activity", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private var groupedActivities: [Date: [Activity]] {
        // Use cached version if available and counts match
        if !cachedGroupedActivities.isEmpty && lastActivitiesCount == trip.activities.count {
            return cachedGroupedActivities
        }
        
        // Fallback to direct grouping if cache is invalid
        return Dictionary(grouping: trip.activities) { activity in
            Calendar.current.startOfDay(for: activity.startTime)
        }
    }
    
    // Update cache when activities change
    private func updateCacheIfNeeded() {
        guard lastActivitiesCount != trip.activities.count else { return }
        
        cachedGroupedActivities = Dictionary(grouping: trip.activities) { activity in
            Calendar.current.startOfDay(for: activity.startTime)
        }
        lastActivitiesCount = trip.activities.count
    }
    
    private func deleteActivities(on date: Date, at offsets: IndexSet) {
        let activitiesOnDate = groupedActivities[date] ?? []
        let idsToRemove = offsets.map { activitiesOnDate[$0].id }
        
        // Update the trip's activities by filtering out the removed ones
        trip.activities.removeAll { activity in
            idsToRemove.contains(activity.id)
        }
        
        // Invalidate cache
        cachedGroupedActivities = [:]
    }
}
