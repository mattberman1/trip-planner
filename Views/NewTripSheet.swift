//
//  NewTripSheet.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/16/25.
//

import SwiftUI
import MapKit

/// A modal sheet for creating a new Trip, with MapKit city autocomplete.
struct NewTripSheet: View {
    // Callback to send the new trip back to the presenter
    var onSave: (Trip) -> Void

    // MARK: – Form State
    @State private var title: String = ""
    @State private var startDate = Date()
    @State private var endDate   = Date()

    // City autocomplete state
    @State private var cityQuery = ""
    @State private var chosenCity: MKLocalSearchCompletion?
    @State private var cityCoordinates: CLLocationCoordinate2D?
    @State private var search = LocationSearchService()

    @Environment(\.dismiss) private var dismiss

    // MARK: – View
    var body: some View {
        NavigationStack {
            Form {
                Section("Trip Details") {
                    // Title
                    TextField("Trip title", text: $title)

                    // City autocomplete
                    TextField("City", text: $cityQuery)
                        .onChange(of: cityQuery) { _, newValue in
                            // Fire new search queries
                            search.update(query: newValue)
                            chosenCity = nil
                        }

                    // Suggestion list (shows only when typing)
                    if !search.results.isEmpty && chosenCity == nil {
                        List(search.results, id: \.self) { completion in
                            Button {
                                Task {
                                    // Resolve coordinates
                                    cityCoordinates = try? await search.coordinates(for: completion)
                                    cityQuery   = completion.title   // show chosen city
                                    chosenCity  = completion
                                }
                            } label: {
                                // Two-line cell: “Austin” / “TX, United States”
                                VStack(alignment: .leading) {
                                    Text(completion.title).bold()
                                    Text(completion.subtitle).font(.caption)
                                }
                            }
                        }
                        .frame(maxHeight: 120) // keep list small
                    }
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
                        let trip = Trip()
                        trip.title     = title
                        trip.startDate = startDate
                        trip.endDate   = endDate
                        if cityCoordinates != nil {
                            trip.cityName = cityQuery
                            // Store coordinates later if desired
                        }
                        onSave(trip)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NewTripSheet { _ in }
}
