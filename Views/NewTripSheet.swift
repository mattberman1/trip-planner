//
//  NewTripSheet.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/16/25.
//


import SwiftUI

/// A modal sheet for creating a Trip.
/// Returns the new Trip via the `onSave` closure.
struct NewTripSheet: View {
    // Call back to whoever presented the sheet
    var onSave: (Trip) -> Void

    // Local form state
    @State private var title: String = ""
    @State private var startDate = Date()
    @State private var endDate   = Date()

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Trip title", text: $title)
                }
                Section("Dates") {
                    DatePicker("Start", selection: $startDate, displayedComponents: .date)
                    DatePicker("End",   selection: $endDate,   displayedComponents: .date)
                }
            }
            .navigationTitle("New Trip")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var trip = Trip()
                        trip.title     = title
                        trip.startDate = startDate
                        trip.endDate   = endDate
                        onSave(trip)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}