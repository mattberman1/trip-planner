//
//  TravelPlannerTests.swift
//  TravelPlannerTests
//
//  Created by Matt Berman on 6/16/25.
//

import XCTest
@testable import TripPlanner

final class TripTests: XCTestCase {
    func testTripInitHasID() {
        XCTAssertNotNil(Trip().id)
    }
}
