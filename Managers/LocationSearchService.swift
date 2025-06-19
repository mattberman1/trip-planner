//
//  LocationSearchService.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/16/25.
//

import MapKit
import Combine

@MainActor
final class LocationSearchService: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {

    @Published var results: [MKLocalSearchCompletion] = []

    private let completer: MKLocalSearchCompleter = {
        let c = MKLocalSearchCompleter()
        c.resultTypes = [ .address, .pointOfInterest]        // city / state / country lines
        return c
    }()

    func setRegion(around coord: CLLocationCoordinate2D, span: CLLocationDegrees = 0.3) {
            completer.region = MKCoordinateRegion(
                center: coord,
                span: .init(latitudeDelta: span, longitudeDelta: span)
            )
        }
    
    override init() {
        super.init()
        completer.delegate = self
    }

    /// Call from your `onChange` when the query changes.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results.filter { !$0.subtitle.isEmpty }
        print("MapKit results:", self.results.map(\.title))
    }
    
    func update(query: String) {
        guard query.count >= 3 else {            // avoid rate-limit
            results.removeAll()
            return
        }
        completer.queryFragment = query
    }

    func clearResults() { results.removeAll() }

    // MARK: - MKLocalSearchCompleterDelegate
    func completer(_ completer: MKLocalSearchCompleter,
                   didUpdateResults results: [MKLocalSearchCompletion]) {
        // Keep only “City, Country” style matches
        self.results = results.filter { !$0.subtitle.isEmpty }
    }

    func completer(_ completer: MKLocalSearchCompleter,
                   didFailWithError error: Error) {
        print("Completer failed:", error)        // FYI: Code -7 is rate-limit
        results.removeAll()
    }

    /// Turn a completion into coordinates (for centering the map later)
    func coordinates(for completion: MKLocalSearchCompletion) async throws -> CLLocationCoordinate2D {
        let request  = MKLocalSearch.Request(completion: completion)
        let response = try await MKLocalSearch(request: request).start()
        guard let item = response.mapItems.first else {
            throw NSError(domain: "LocationSearchService", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "No map item"])
        }
        return item.placemark.coordinate
    }
}
