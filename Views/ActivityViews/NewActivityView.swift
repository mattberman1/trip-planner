//
//  NewActivityView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//

import SwiftUI
import MapKit

/// Sheet that lets a user create a new itinerary item and add it to a trip.
struct NewActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var tripStore: TripStore

    /// The trip we’re editing.
    @Binding var trip: Trip

    // MARK: - Local state

    @State private var title = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(60 * 60)
    @State private var category: ActivityCategory = .places
    @State private var isAllDay = false
    @State private var notes = ""
    @State private var selectedLocation: MKMapItem?
    @State private var showingLocationSearch = false

    // MARK: - View

    var body: some View {
        NavigationStack {
            Form {
                // Activity basics
                Section("Activity Details") {
                    TextField("Activity Name", text: $title)

                    Picker("Category", selection: $category) {
                        ForEach(ActivityCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }

                    Toggle("All Day", isOn: $isAllDay)

                    DatePicker("Start",
                               selection: $startTime,
                               displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])

                    DatePicker("End",
                               selection: $endTime,
                               displayedComponents: isAllDay ? .date : [.date, .hourAndMinute])

                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                // Location
                Section("Location") {
                    if let loc = selectedLocation {
                        VStack(alignment: .leading) {
                            Text(loc.name ?? "Unknown Location")
                                .font(.headline)
                            Text(loc.placemark.title ?? "")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Button {
                        showingLocationSearch = true
                    } label: {
                        Label(selectedLocation == nil
                              ? "Search Location"
                              : "Change Location",
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
                    Button("Add") { addActivity() }
                        .disabled(title.isEmpty || selectedLocation == nil)
                }
            }
            .sheet(isPresented: $showingLocationSearch) {
                // `LocationSearchView` is part of the project.
                LocationSearchView(selectedLocation: $selectedLocation)
            }
        }
    }

    // MARK: - Helpers

    /// Persists the new activity to the bound `trip`, then dismisses the sheet.
    private func addActivity() {
        guard let loc = selectedLocation,
              let latitude = loc.placemark.location?.coordinate.latitude,
              let longitude = loc.placemark.location?.coordinate.longitude else { return }

        let activity = Activity(
            title: title,
            startTime: startTime,
            endTime: endTime,
            location: Location(
                name: loc.name ?? "Unknown",
                latitude: latitude,
                longitude: longitude
            ),
            category: category,
            notes: notes,
            isAllDay: isAllDay
        )

        var updatedTrip = trip
        updatedTrip.activities.append(activity)
        tripStore.updateTrip(updatedTrip)

        dismiss()
    }
}
