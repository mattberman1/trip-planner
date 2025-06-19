//
//  ContentView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/16/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var store: TripStore?
    @State private var showingNewTrip = false     // ← NEW

    var body: some View {
        NavigationStack {
            Group {
                if let store = store {
                    List(store.trips) { trip in
                        NavigationLink {
                            TripDetailView(trip: trip)
                        } label: {
                            Text(trip.title.isEmpty ? "Untitled Trip" : trip.title)
                        }
                    }
                } else {
                    ProgressView()
                        .onAppear { store = TripStore(context: modelContext) }
                }
            }
            .navigationTitle("Trips")
            .toolbar {
                Button {
                    showingNewTrip = true
                } label: {
                    Label("Add Trip", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingNewTrip) {
                if let store = store {
                    NewTripSheet { trip in
                        store.addTrip(trip)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Trip.self, Activity.self], inMemory: true)
}
