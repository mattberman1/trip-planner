//
//  NewActivityView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI
import MapKit
import EventKit

struct NewActivityView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tripStore: TripStore
    @Binding var trip: Trip
    
    @State private var title = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)
    @State private var category: ActivityCategory = .places
    @State private var notes = ""
    @State private var selectedLocation: MKMapItem?
    @State private var showingLocationSearch = false
    
    private let eventStore = EKEventStore()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Activity Details") {
                    TextField("Activity Name", text: $title)
                    
                    Picker("Category", selection: $category) {
                        ForEach(ActivityCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    
                    DatePicker("Start Time", selection: $startTime)
                    DatePicker("End Time", selection: $endTime)
                    
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Location") {
                    if let location = selectedLocation {
                        VStack(alignment: .leading) {
                            Text(location.name ?? "Unknown Location")
                                .font(.headline)
                            Text(location.placemark.title ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: { showingLocationSearch = true }) {
                        Label(selectedLocation == nil ? "Search Location" : "Change Location", 
                              systemImage: "location.magnifyingglass")
                    }
                }
            }
            .navigationTitle("New Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addActivity()
                    }
                    .disabled(title.isEmpty || selectedLocation == nil)
                }
            }
            .sheet(isPresented: $showingLocationSearch) {
                LocationSearchView(selectedLocation: $selectedLocation)
            }
        }
    }
    
    private func addActivity() {
        guard let location = selectedLocation,
              let latitude = location.placemark.location?.coordinate.latitude,
              let longitude = location.placemark.location?.coordinate.longitude else { return }
        
        let activity = Activity(
            title: title,
            startTime: startTime,
            endTime: endTime,
            location: Location(
                name: location.name ?? "Unknown",
                latitude: latitude,
                longitude: longitude
            ),
            category: category,
            notes: notes
        )
        
        var updatedTrip = trip
        updatedTrip.activities.append(activity)
        tripStore.updateTrip(updatedTrip)
        
        // Request calendar access for future integration
        eventStore.requestAccess(to: .event) { granted, error in
            // Calendar access will be used in future updates
        }
        
        dismiss()
    }
}