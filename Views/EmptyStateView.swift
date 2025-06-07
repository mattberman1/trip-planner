//
//  EmptyStateView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "airplane.circle")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            Text("Select a trip to view details")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Create a new trip to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}