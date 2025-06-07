//
//  TripStore.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI

class TripStore: ObservableObject {
    @Published var trips: [Trip] = [] {
        didSet {
            saveTrips()
        }
    }
    
    init() {
        loadTrips()
    }
    
    func addTrip(_ trip: Trip) {
        trips.append(trip)
    }
    
    func updateTrip(_ trip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index] = trip
        }
    }
    
    func deleteTrip(_ trip: Trip) {
        trips.removeAll { $0.id == trip.id }
    }
    
    private func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: "SavedTrips")
        }
    }
    
    private func loadTrips() {
        if let data = UserDefaults.standard.data(forKey: "SavedTrips"),
           let decoded = try? JSONDecoder().decode([Trip].self, from: data) {
            trips = decoded
        }
    }
}