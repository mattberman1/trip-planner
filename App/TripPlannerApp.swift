//
//  TravelPlannerApp.swift
//  TravelPlanner
//
//  Created by Matt Berman on 6/16/25.
//

import SwiftUI
import SwiftData

@main
struct TripPlannerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()          // placeholder view for now
                .modelContainer(for: [Trip.self, Activity.self])
        }
    }
}
