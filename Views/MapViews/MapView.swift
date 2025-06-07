//
//  MapView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    let trip: Trip
    let annotations: [ActivityAnnotation]
    @State private var region = MKCoordinateRegion()
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position) {
            ForEach(annotations) { annotation in
                Annotation(annotation.activity.title, coordinate: annotation.coordinate) {
                    VStack {
                        Image(systemName: annotation.activity.category.icon)
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(annotation.activity.category.color)
                                    .frame(width: 30, height: 30)
                            )
                        
                        Text(annotation.activity.title)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(4)
                    }
                }
            }
        }
        .onAppear {
            updatePosition()
        }
        .onChange(of: annotations.count) {
            updatePosition()
        }
    }
    
    private func updatePosition() {
        guard !annotations.isEmpty else { return }
        
        let coordinates = annotations.map { $0.coordinate }
        let minLat = coordinates.map { $0.latitude }.min() ?? 0
        let maxLat = coordinates.map { $0.latitude }.max() ?? 0
        let minLon = coordinates.map { $0.longitude }.min() ?? 0
        let maxLon = coordinates.map { $0.longitude }.max() ?? 0
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: max(0.1, (maxLat - minLat) * 1.5),
            longitudeDelta: max(0.1, (maxLon - minLon) * 1.5)
        )
        
        position = .region(MKCoordinateRegion(center: center, span: span))
    }
}
