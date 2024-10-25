//
//  HomeView.swift
//  Healthify
//
//  Created by Guest Damon on 7/31/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    var body: some View {
        VStack {
            Spacer()
            
            TabView{
                HomePageView()
                    .id(selectedTab == 1 ? UUID() : nil)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Dashboard")
                    }
               
                TestTriageView()
                    .id(selectedTab == 0 ? UUID() : nil)
                    .tabItem {
                        Label("Diagnostic", systemImage: "heart.text.square")
                    }
                /* TriageView()
                 .id(selectedTab == 0 ? UUID() : nil)
                 .tabItem {
                 Label("Diagnostic", systemImage: "heart.text.square")
                 } */
                
                MapView()
                    .id(selectedTab == 2 ? UUID() : nil)
                    .tabItem {
                        Image(systemName: "person.crop.circle.fill")
                        Text("Hospital Locations")
                    }
                    .tag(2)
            }
            
        }
    }
}
