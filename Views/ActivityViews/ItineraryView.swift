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
    @Binding var selectedActivity: Activity?
    
    /// Cached, sorted activities for efficient rendering
    @State private var cachedSortedActivities: [Activity] = []
    @State private var lastActivitiesCount = 0
    
    var body: some View {
        VStack(spacing: 0) {
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
                ForEach(sortedActivities) { activity in
                    Button(action: {
                        selectedActivity = activity
                    }) {
                        ActivityRowView(activity: activity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .onDelete(perform: deleteActivities)
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
        .onAppear(perform: updateCacheIfNeeded)
        .onChange(of: trip.activities) { _ in
            updateCacheIfNeeded()
        }
    }
    
    /// Sorted activities, cached for performance
    private var sortedActivities: [Activity] {
        if !cachedSortedActivities.isEmpty && lastActivitiesCount == trip.activities.count {
            return cachedSortedActivities
        }

        cachedSortedActivities = trip.activities.sorted { $0.startTime < $1.startTime }
        lastActivitiesCount = trip.activities.count
        return cachedSortedActivities
    }

    private func updateCacheIfNeeded() {
        guard lastActivitiesCount != trip.activities.count else { return }
        cachedSortedActivities = trip.activities.sorted { $0.startTime < $1.startTime }
        lastActivitiesCount = trip.activities.count
    }

    private func deleteActivities(at offsets: IndexSet) {
        trip.activities.remove(atOffsets: offsets)
        cachedSortedActivities = []
    }
}
