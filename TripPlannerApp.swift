//
//  TripPlannerApp.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI

@main
struct TripPlannerApp: App {
    @StateObject private var tripStore = TripStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tripStore)
        }
    }
}
