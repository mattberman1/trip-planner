//
//  TripListView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI

struct TripListView: View {
    @EnvironmentObject var tripStore: TripStore
    @Binding var showingNewTrip: Bool
    @Binding var selectedTrip: Trip?
    
    var body: some View {
        List {
            ForEach(tripStore.trips) { trip in
                TripRowView(trip: trip)
                    .onTapGesture {
                        selectedTrip = trip
                    }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    tripStore.deleteTrip(tripStore.trips[index])
                }
            }
        }
        .navigationTitle("My Trips")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingNewTrip = true }) {
                    Label("New Trip", systemImage: "plus")
                }
            }
        }
    }
}