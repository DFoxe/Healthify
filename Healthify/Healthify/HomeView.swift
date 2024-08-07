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
                
                // Additional tabs for navigation
                Text("Activity Tracking")
                    .tabItem {
                        Image(systemName: "figure.walk")
                        Text("Activity")
                    }
                
                MedicationView()
                    .tabItem {
                        Image(systemName: "pills.fill")
                        Text("Medication")
                    }
                
                AppointmentView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Appointments")
                    }
                
                Text("Profile")
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("profile")
                    }
            }
            
        }
    }
}
