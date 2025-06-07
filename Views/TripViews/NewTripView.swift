//
//  NewTripView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//


import SwiftUI

struct NewTripView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tripStore: TripStore
    @Binding var selectedTrip: Trip?
    
    @State private var tripName = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400 * 7)
    @State private var cities: [String] = []
    @State private var newCity = ""
    @State private var showingCityPicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Trip Details") {
                    TextField("Trip Name", text: $tripName)
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section("Cities") {
                    ForEach(cities, id: \.self) { city in
                        Text(city)
                    }
                    .onDelete { indexSet in
                        cities.remove(atOffsets: indexSet)
                    }
                    
                    Button(action: { showingCityPicker = true }) {
                        Label("Add City", systemImage: "plus.circle.fill")
                    }
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let newTrip = Trip(
                            name: tripName,
                            startDate: startDate,
                            endDate: endDate,
                            cities: cities
                        )
                        tripStore.addTrip(newTrip)
                        selectedTrip = newTrip
                        dismiss()
                    }
                    .disabled(tripName.isEmpty || cities.isEmpty)
                }
            }
            .sheet(isPresented: $showingCityPicker) {
                CitySearchView(cities: $cities)
            }
        }
    }
}