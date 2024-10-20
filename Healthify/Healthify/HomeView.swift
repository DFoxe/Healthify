//
//  HomeView.swift
//  Healthify
//
//  Created by Guest Damon on 7/31/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            
            TabView{
                HomePageView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Dashboard")
                    }
                TriageView()
                    .tabItem {
                        Label("Diagnostic", systemImage: "heart.text.square")
                    }
                
                MedicationView()
                    .tabItem {
                        Image(systemName: "pills.fill")
                        Text("Medication")
                    }
                
                /*AppointmentView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Appointments")
                         }*/
                
                MapView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Hospital Locations")
                    }
            }
            
        }
    }
}
