//
//  ContentView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var tripStore: TripStore
    @State private var showingNewTrip = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            TripListView(showingNewTrip: $showingNewTrip)
                .navigationDestination(for: Trip.self) { trip in
                    TripDetailView(trip: binding(for: trip))
                }
        }
        .sheet(isPresented: $showingNewTrip) {
            NewTripView { newTrip in
                if let newTrip = newTrip {
                    path.append(newTrip)
                }
            }
        }
    }
    
        private func binding(for trip: Trip) -> Binding<Trip> {
        guard let index = tripStore.trips.firstIndex(where: { $0.id == trip.id }) else {
            return .constant(trip)
        }
        return $tripStore.trips[index]
    }
}
