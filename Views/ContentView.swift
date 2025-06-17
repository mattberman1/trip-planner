//
//  ContentView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/16/25.
//

import SwiftUI

struct ContentView: View {
    @State private var store = TripStore()
    @State private var showingNewTrip = false     // ← NEW

    var body: some View {
        NavigationView {
            List(store.trips) { trip in
                Text(trip.title.isEmpty ? "Untitled Trip" : trip.title)
            }
            .navigationTitle("Trips")
            .toolbar {
                Button {
                    showingNewTrip = true
                } label: {
                    Label("Add Trip", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingNewTrip) {     // ← NEW
                NewTripSheet { trip in
                    store.addTrip(trip)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
