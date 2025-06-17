//
//  ContentView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/16/25.
//

import SwiftUI

struct ContentView: View {
    @State private var store = TripStore()

    var body: some View {
        NavigationView {
            List(store.trips) { trip in
                Text(trip.title.isEmpty ? "Untitled Trip" : trip.title)
            }
            .navigationTitle("Trips")
            .toolbar {
                Button {
                    let newTrip = Trip()
                    newTrip.title = "New Trip"
                    store.addTrip(newTrip)
                } label: {
                    Label("Add Trip", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
