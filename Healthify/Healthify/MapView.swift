//
//  MapView.swift
//  Healthify
//
//  Created by Guest Damon on 10/13/24.
//

import Foundation
import SwiftUI
import MapKit

// Struct to hold location data
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    
    // An array of preloaded locations
    @State private var urgentCares = [
        Location(name: "Central Park", coordinate: CLLocationCoordinate2D(latitude: 40.785091, longitude: -73.968285)),
        Location(name: "Statue of Liberty", coordinate: CLLocationCoordinate2D(latitude: 40.689247, longitude: -74.044502))
        ]
    @State private var emergencyRooms = [
        Location(name: "Times Square", coordinate: CLLocationCoordinate2D(latitude: 40.758896, longitude: -73.985130))
        
    ]
    
    // Region to center the map on (New York in this case)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.758896, longitude: -73.985130), // Times Square as the center
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Zoom level
    )
    
    var body: some View {
        VStack{
            /*Picker("Select option", selection: $selectedOption) {
                Text("Urgent Care").tag(
            }*/
            Spacer()
            
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding()
                
                Map(coordinateRegion: $region, annotationItems: urgentCares) { location in
                    MapMarker(coordinate: location.coordinate, tint: .red)
                }
                .cornerRadius(12)
            }
            .frame(height:300)
            Spacer()
        }
        .padding(.horizontal)
    }
    
}
