//
//  NewActivitySheet.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/19/25.
//


import SwiftUI
import MapKit

struct NewActivitySheet: View {
    var onSave: (Activity) -> Void
    let tripID: UUID                      // passed in by TripDetailView
    let cityName: String

    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var when  = Date()
    @State private var category: ActivityCategory = .place

    // Location search
    @State private var query = ""
    @State private var selected: MKLocalSearchCompletion?
    @State private var coord: CLLocationCoordinate2D?
    @StateObject private var search = LocationSearchService()
    @State private var cityCoord: CLLocationCoordinate2D?

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)

                DatePicker("Date & time", selection: $when)

                Picker("Category", selection: $category) {
                    ForEach(ActivityCategory.allCases, id: \.self) {
                        Text($0.rawValue.capitalized)
                    }
                }

                // Location field + suggestions
                TextField("Location", text: $query)
                    .onChange(of: query) { _, new in
                        if new.count >= 3 { search.update(query: new) }
                        else { search.clearResults() }
                        selected = nil
                    }

                if !search.results.isEmpty && selected == nil {
                    List(search.results.prefix(5), id: \.self) { c in
                        Button {
                            Task {
                                coord   = try? await search.coordinates(for: c)
                                query   = c.title
                                selected = c
                                search.clearResults()
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                Text(c.title).bold()
                                Text(c.subtitle).font(.caption)
                            }
                        }
                    }
                    .frame(maxHeight: 180)
                }
            }
            .navigationTitle("New Activity")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(title.isEmpty || selected == nil)
                }
            }
        }
        .task {
            if cityCoord == nil {
                cityCoord = await geocode(cityName)
                if let c = cityCoord {
                    search.setRegion(around: c)
                }
            }
        }
    }

    private func save() {
        let a = Activity(
            tripID: tripID,
            title: title,
            date:  when,
            category: category,
            latitude: coord?.latitude ?? 0,
            longitude: coord?.longitude ?? 0
        )
        onSave(a)
        dismiss()
    }
    
    /// Geocode the trip's city name once to bias location suggestions.
    private func geocode(_ query: String) async -> CLLocationCoordinate2D? {
        var request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let response = try? await MKLocalSearch(request: request).start()
        return response?.mapItems.first?.placemark.coordinate
    }
}
