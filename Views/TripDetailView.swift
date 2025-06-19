//
//  TripDetailView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/18/25.
//

import SwiftUI
import MapKit
import SwiftData

/// Detail view for a single trip.
/// - Sidebar (fixed 240 pt) lists activities.
/// - Map pane shows trip locations (placeholder for now).
/// The sidebar can’t be collapsed because the nav-toolbar is hidden.
struct TripDetailView: View {
    let trip: Trip
    @Environment(\.modelContext) private var context        
    @State private var showActivitySheet = false
    
    @State private var mapPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: .init(latitude: 0, longitude: 0),
            span:   .init(latitudeDelta: 180, longitudeDelta: 360)
        )
    )

    var body: some View {
        NavigationSplitView {
            List(sortedActivities) { activity in
                Text(activity.title)
            }
            .overlay {
                if sortedActivities.isEmpty {
                    ContentUnavailableView("No activities yet",
                                           systemImage: "list.bullet")
                }
            }
            .navigationSplitViewColumnWidth(240)
        } detail: {
            Map(position: $mapPosition) { }
        }
        .navigationTitle(trip.title.isEmpty ? "Trip" : trip.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showActivitySheet = true } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showActivitySheet) {
            NewActivitySheet(
                onSave: { activity in
                trip.activities.append(activity);        try? context.save()
            }, tripID: trip.id,
                cityName: trip.cityName )
        }
        .onAppear(perform: setInitialRegion)
    }

    // MARK: – Helpers
    private var sortedActivities: [Activity] {
        trip.activities.sorted { $0.date < $1.date }
    }

    private func setInitialRegion() {
        // TODO: Replace with real coordinates once stored on the model.
    }
}

#if DEBUG
#Preview {
    TripDetailView(trip: Trip())
        .modelContainer(for: [Trip.self, Activity.self], inMemory: true)
}
#endif
