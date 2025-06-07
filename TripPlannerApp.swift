//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//
<<<<<<< HEAD
import SwiftUI

@main
struct TripPlannerApp: App {
=======

import SwiftUI
import SwiftData

@main
struct TripPlannerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

>>>>>>> 7c0ee66 (Initial Commit)
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
<<<<<<< HEAD
=======
        .modelContainer(sharedModelContainer)
>>>>>>> 7c0ee66 (Initial Commit)
    }
}
