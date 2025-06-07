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
    @State private var selectedActivity: Activity?
    @State private var annotations: [ActivityAnnotation] = []
    @State private var lastActivitiesCount = 0
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Map Section
                MapView(trip: trip, annotations: annotations, selectedActivity: $selectedActivity)
                    .frame(height: 250)
                
                // Itinerary Section
                ItineraryView(trip: $trip, showingNewActivity: $showingNewActivity, selectedActivity: $selectedActivity)
                    .padding()
            }
        }
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Trips")
                    }
                }
            }
        }
        .onAppear {
            updateAnnotations()
            lastActivitiesCount = trip.activities.count
        }
        .onChange(of: trip.activities) { _ in
            // Update annotations when activities change
            updateAnnotations()
            lastActivitiesCount = trip.activities.count
        }
        .sheet(isPresented: $showingNewActivity) {
            NewActivityView(trip: $trip)
        }
    }
    
    private func updateAnnotations() {
        // Only update if annotations are actually different
        let newAnnotations = trip.activities.map { activity in
            ActivityAnnotation(
                activity: activity,
                coordinate: CLLocationCoordinate2D(
                    latitude: activity.location.latitude,
                    longitude: activity.location.longitude
                )
            )
        }
        
        if Set(newAnnotations.map(\.id)) != Set(annotations.map(\.id)) {
            annotations = newAnnotations
        }
    }
}

struct ActivityAnnotation: Identifiable, Equatable {
    let id = UUID()
    let activity: Activity
    let coordinate: CLLocationCoordinate2D
    
    static func == (lhs: ActivityAnnotation, rhs: ActivityAnnotation) -> Bool {
        lhs.id == rhs.id && 
        lhs.activity.id == rhs.activity.id &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

