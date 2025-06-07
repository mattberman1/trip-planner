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
        }
        .onChange(of: trip.activities) { _ in
            updateAnnotations()
        }
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

