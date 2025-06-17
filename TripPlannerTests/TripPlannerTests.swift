//
//  TravelPlannerTests.swift
//  TravelPlannerTests
//
//  Created by Matt Berman on 6/16/25.
//

import XCTest
@testable import TripPlanner

final class TripStoreTests: XCTestCase {

    @MainActor func testAddTripPersists() {
        // Arrange
        let store = TripStore()          // uses in-memory container
        let trip  = Trip()
        trip.title = "Test Trip"

        // Act
        store.addTrip(trip)

        // Assert
        XCTAssertTrue(
            store.trips.contains(where: { $0.id == trip.id }),
            "Trip should be present after calling addTrip(_:)"
        )
    }
}
