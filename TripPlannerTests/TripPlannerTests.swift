//
//  TripPlannerTests.swift
//  TripPlannerTests
//
//  Created by Matt Berman on 6/7/25.
//

import Testing
@testable import TripPlanner

struct TripPlannerTests {

    @Test func activityValidation() async throws {
        let location = Location(name: "Test", latitude: 0, longitude: 0)
        let start = Date()
        let end = start.addingTimeInterval(3600)

        let validActivity = Activity(
            title: "Example",
            startTime: start,
            endTime: end,
            location: location,
            category: .places
        )

        #expect(validActivity.isValid)

        let invalidActivity = Activity(
            title: "Invalid",
            startTime: end,
            endTime: start,
            location: location,
            category: .places
        )

        #expect(!invalidActivity.isValid)
    }

}
