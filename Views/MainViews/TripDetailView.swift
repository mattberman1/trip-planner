//
//  TripDetailView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI
import MapKit

struct TripDetailView: View {
    @Binding var trip: Trip
    @State private var showingNewActivity = false
    @State private var mapRegion = MKCoordinateRegion()
    @State private var annotations: [ActivityAnnotation] = []
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar: Itinerary
            ItineraryView(trip: $trip, showingNewActivity: $showingNewActivity)
                .navigationSplitViewColumnWidth(min: 300, ideal: 400)
        } detail: {
            // Detail: Map
            MapView(trip: trip, annotations: annotations)
                .navigationTitle("Map")
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationTitle(trip.name)
        .sheet(isPresented: $showingNewActivity) {
            NewActivityView(trip: $trip)
        }
        .onChange(of: trip.activities.count) {
            updateAnnotations()
        }
        .onAppear {
            updateAnnotations()
        }
    }
    
    private func updateAnnotations() {
        annotations = trip.activities.map { activity in
            ActivityAnnotation(
                activity: activity,
                coordinate: CLLocationCoordinate2D(
                    latitude: activity.location.latitude,
                    longitude: activity.location.longitude
                )
            )
        }
    }
}

struct ActivityAnnotation: Identifiable {
    let id = UUID()
    let activity: Activity
    let coordinate: CLLocationCoordinate2D
}

