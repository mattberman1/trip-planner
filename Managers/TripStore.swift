//
//  TripStore.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/16/25.
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor final class TripStore {
    // MARK: – Public, reactive list
    private(set) var trips: [Trip] = []

    // MARK: – Private
    private let context: ModelContext

    // MARK: – Init
    init(context: ModelContext) {
        self.context = context
        loadTrips()
    }

    // MARK: – CRUD
    func addTrip(_ trip: Trip) {
        context.insert(trip)
        try? context.save()
        trips.append(trip)
    }

    func addActivity(_ activity: Activity, to tripID: UUID) {
        guard let trip = trips.first(where: { $0.id == tripID }) else { return }
        trip.activities.append(activity)
        context.insert(activity)
        try? context.save()
        // trips array already holds the same Trip reference, so UI will update
    }

    // MARK: – Initial fetch
    private func loadTrips() {
        trips = (try? context.fetch(FetchDescriptor<Trip>())) ?? []
    }
}
