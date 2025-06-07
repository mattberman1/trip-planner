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
                ForEach(groupedActivities.keys.sorted(), id: \.self) { date in
                    Section(header: Text(dateFormatter.string(from: date))) {
                        ForEach(groupedActivities[date] ?? []) { activity in
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