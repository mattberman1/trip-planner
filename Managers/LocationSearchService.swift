//
//  LocationSearchService.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/16/25.
//

import Foundation
import MapKit             // MKLocalSearch & MKLocalSearchCompleter
import Observation        // for @Observable

/// Simple wrapper around MKLocalSearchCompleter that publishes cities.
@Observable
@MainActor
final class LocationSearchService: NSObject, MKLocalSearchCompleterDelegate {

    // Published results UI can bind to
    private(set) var results: [MKLocalSearchCompletion] = []

    private let completer: MKLocalSearchCompleter = {
        let c = MKLocalSearchCompleter()
        c.resultTypes = .address
        return c
    }()

    override init() {
        super.init()
        completer.delegate = self
    }

    /// Update the query to fetch new completions.
    func update(query: String) {
        completer.queryFragment = query
    }

    // MARK: – MKLocalSearchCompleterDelegate
    func completer(_ completer: MKLocalSearchCompleter,
                   didUpdateResults results: [MKLocalSearchCompletion]) {
        // Keep only items that look like a city (have no street #)
        self.results = results.filter { $0.subtitle.contains(",") }
    }

    func completer(_ completer: MKLocalSearchCompleter,
                   didFailWithError error: Error) {
        print("Completer failed:", error)
        results = []
    }

    // MARK: – Resolve a completion to coordinates
    func coordinates(for completion: MKLocalSearchCompletion) async throws -> CLLocationCoordinate2D {
        let request = MKLocalSearch.Request(completion: completion)
        let response = try await MKLocalSearch(request: request).start()
        guard let item = response.mapItems.first else {
            throw NSError(domain: "NoMapItem", code: -1)
        }
        return item.placemark.coordinate
    }
}
