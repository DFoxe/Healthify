//
//  ContentView.swift
//  Healthify
//
//  Created by Guest Damon on 7/24/24.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @State private var name: String = ""
    var body: some View {
        HomeView()
    }
}

struct DetailView: View {
    @State private var selectedDate = Date()
    @State private var navigateToDashboard = false
    @Binding var name: String

    var body: some View {
        NavigationStack{
        VStack{
            Spacer()
            Text("Hello, \(name) Enter your Date of Birth")
                .font(.title)
                .padding()

            DatePicker("Date of Birth", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()

                Button(action: {
                    //process DOB here
                    navigateToDashboard = true
                }) {
                    Text("Continue")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
                .navigationDestination(isPresented: $navigateToDashboard) {
                    HomeView()
                }
            }
            .navigationBarTitle("Welcome")
        }
    }
}

#Preview {
    ContentView()
}
