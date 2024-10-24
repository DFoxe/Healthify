//
//  MapView.swift
//  Healthify
//
//  Created by Guest Damon on 10/13/24.
//


//  Healthify
//
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
        Location(name: "CityMD West 125th", coordinate: CLLocationCoordinate2D(latitude: 40.809010, longitude: -73.948402)),
        Location(name: "CityMD West 104th", coordinate: CLLocationCoordinate2D(latitude: 40.799480, longitude: -73.967941)),
        Location(name: "+MEDRITE Manhattanville", coordinate: CLLocationCoordinate2D(latitude: 40.8133592, longitude: -73.9560285))
    ]
    
    @State private var emergencyRooms = [
        Location(name: "Mount Sinai Hospital", coordinate: CLLocationCoordinate2D(latitude: 40.790310, longitude: -73.952103)),
        Location(name: "Mount Sinai MorningSide", coordinate: CLLocationCoordinate2D(latitude: 40.804660, longitude: -73.961670)),
        Location(name: "Harlem Hospital Center", coordinate: CLLocationCoordinate2D(latitude: 43.091061, longitude: -75.661591))
        
    ]
    @State private var selected = "urgentCares"
    
    
    
    // Region to center the map on (New York in this case)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.808984, longitude: -73.948574), // Harlem as the center
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // Zoom level
    )
    
    var body: some View {
        VStack{
            Spacer()
            
            Picker("Resources", selection: $selected) {
                Text("Urgent Cares").tag("urgentCares")
                Text("Emergency Rooms").tag("emergencyRooms")
            }
            .pickerStyle(.segmented)
            
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding()
                
                if selected == "urgentCares" {
                    Map(coordinateRegion: $region, annotationItems: urgentCares) { location in
                        MapMarker(coordinate: location.coordinate, tint: .red)
                    }
                    .cornerRadius(12)
                }
                else if selected == "emergencyRooms"{
                    Map(coordinateRegion: $region, annotationItems: emergencyRooms) { location in
                        MapMarker(coordinate: location.coordinate, tint: .red)
                    }
                    .cornerRadius(12)
                }
            }
            .frame(height:300)
            Spacer()
        }
        .padding(.horizontal)
    }
    
}

