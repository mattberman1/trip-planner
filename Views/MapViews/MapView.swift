//
//  MapView.swift
//  TripPlanner
//
//  Created by Matt Berman on 6/7/25.
//

import SwiftUI
import MapKit

struct ActivityMapAnnotation: View {
    let annotation: ActivityAnnotation
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: annotation.activity.category.icon)
                .foregroundColor(.white)
                .background(
                    Circle()
                        .fill(annotation.activity.category.color)
                        .frame(width: 30, height: 30)
                )
            
            if isSelected {
                Text(annotation.activity.title)
                    .font(.caption)
                    .padding(4)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(4)
                    .shadow(radius: 2)
            }
        }
        .onTapGesture(perform: onTap)
    }
}

struct MapView: View {
    let trip: Trip
    let annotations: [ActivityAnnotation]
    @Binding var selectedActivity: Activity?
    @State private var position: MapCameraPosition = .automatic
    @State private var selectedAnnotation: ActivityAnnotation?
    
    var body: some View {
        Map(position: $position) {
            ForEach(annotations) { annotation in
                Annotation(
                    annotation.activity.title,
                    coordinate: annotation.coordinate,
                    anchor: .center
                ) {
                    ActivityMapAnnotation(
                        annotation: annotation,
                        isSelected: selectedAnnotation?.id == annotation.id
                    ) {
                        handleAnnotationTap(annotation: annotation)
                    }
                }
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .onAppear {
            updatePosition()
        }
        .onChange(of: annotations.count) { oldCount, newCount in
            if oldCount != newCount {
                updatePosition()
            }
        }
        .onChange(of: selectedActivity) { oldValue, newValue in
            if let activity = newValue, 
               let annotation = annotations.first(where: { $0.activity.id == activity.id }),
               selectedAnnotation?.id != annotation.id {
                selectedAnnotation = annotation
                withAnimation {
                    position = .region(MKCoordinateRegion(
                        center: annotation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }
            } else if newValue == nil {
                selectedAnnotation = nil
            }
        }
    }
    
    private func handleAnnotationTap(annotation: ActivityAnnotation) {
        withAnimation {
            if selectedAnnotation?.id == annotation.id {
                selectedAnnotation = nil
                selectedActivity = nil
            } else {
                selectedAnnotation = annotation
                selectedActivity = annotation.activity
            }
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
