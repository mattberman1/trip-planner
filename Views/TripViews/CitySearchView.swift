//
//  CitySearchView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI
import MapKit

struct CitySearchView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var cities: [String]
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    
    var body: some View {
        NavigationView {
            List(searchResults, id: \.self) { item in
                Button(action: {
                    if let city = item.placemark.locality {
                        cities.append(city)
                        dismiss()
                    }
                }) {
                    VStack(alignment: .leading) {
                        Text(item.placemark.locality ?? "Unknown")
                            .font(.headline)
                        Text(item.placemark.administrativeArea ?? "")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { newValue in
                searchForCities(newValue)
            }
            .navigationTitle("Search Cities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private func searchForCities(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else { return }
            searchResults = response.mapItems.filter { $0.placemark.locality != nil }
        }
    }
}