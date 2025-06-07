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
    @State private var selectedTrip: Trip?
    
    var body: some View {
        NavigationSplitView {
            TripListView(showingNewTrip: $showingNewTrip, selectedTrip: $selectedTrip)
        } detail: {
            if let trip = selectedTrip {
                TripDetailView(trip: binding(for: trip))
            } else {
                EmptyStateView()
            }
        }
        .sheet(isPresented: $showingNewTrip) {
            NewTripView(selectedTrip: $selectedTrip)
        }
    }
    
    private func binding(for trip: Trip) -> Binding<Trip> {
        Binding(
            get: { trip },
            set: { tripStore.updateTrip($0) }
        )
    }
}
