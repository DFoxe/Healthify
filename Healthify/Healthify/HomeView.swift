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
               
                TestTriageView()
                    .tabItem {
                        Label("Diagnostic", systemImage: "heart.text.square")
                    }
                /* TriageView()
                 .tabItem {
                 Label("Diagnostic", systemImage: "heart.text.square")
                 } */
                
                MapView()
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Hospital Locations")
                    }
            }
            
        }
    }
}
