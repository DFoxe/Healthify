//
//  MedicationView.swift
//  Healthify
//
//  Created by Guest Damon on 7/31/24.
//

import Foundation
import SwiftUI

struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Cancel") {
            dismiss()
        }
        .font(.title)
        .padding()
    }
}
struct MedicationView: View {
    @State private var showingSheet = false
    struct Medication: Identifiable{
        let id = UUID()
        var name: String
        var dosage: String
        var frequency: String
        var imageName: String
    }
    let medications: [Medication] = [
        Medication(name: "Aspirin", dosage:"500mg", frequency:"Once a day", imageName: "house.fill")]
    var body: some View {
        //  NavigationView{
        VStack{
            List(medications){medication in HStack {
                Image(medication.imageName)
                    .resizable()
                    .frame(width:50, height: 50)
                    .cornerRadius(8)
                VStack(alignment: .leading){
                    Text(medication.name)
                        .font(.headline)
                    Text("Dosage: \(medication.dosage)")
                    Text("Frequency: \(medication.frequency)")
                }

            }}
            Button("New Medication") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                SheetView()
            }
            Spacer()
        }
   // }


    }
}
