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

    enum Mode { case city, poi }
    private var mode: Mode = .city
    private var regionHint: MKCoordinateRegion?

    /// Configure the completer for the requested search mode.
    private func configure(for mode: Mode) {
        self.mode = mode
        completer.resultTypes = mode == .city ? [.address] : [.pointOfInterest]
    }

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

    /// Push keystrokes in here.
    func update(query: String, mode: Mode, region: MKCoordinateRegion? = nil) {
        if mode != self.mode { configure(for: mode) }
        if let region = region {
            completer.region = region
            regionHint = region
        }
        guard query.count >= 3 else {
            results.removeAll()
            return
        }
        completer.queryFragment = query
    }

    func clearResults() { results.removeAll() }

    /// Very lightweight “is this a city?” heuristic.
    private func isCity(_ item: MKLocalSearchCompletion) -> Bool {
        !item.title.contains(",") && item.subtitle.contains(",")
    }

    // MARK: - MKLocalSearchCompleterDelegate
    func completer(_ completer: MKLocalSearchCompleter,
                   didUpdateResults results: [MKLocalSearchCompletion]) {
        switch mode {
        case .city:
            self.results = results.filter(isCity)
        case .poi:
            self.results = results
        }
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
