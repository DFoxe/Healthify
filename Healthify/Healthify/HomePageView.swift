//
//  HomePageView.swift
//  Healthify
//
//  Created by Guest Damon on 7/31/24.
//

import Foundation
import SwiftUI

struct HomePageView: View {
    var body: some View {
        VStack{
            Text("HeartHandle")
                .font(.largeTitle)
                .padding(.top)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ActivityTrackingSection()
                    MedicationsSection()
                    /*AppointmentsSection()*/
                }
                .padding()
            }
        }
    }
}
struct ActivityTrackingSection: View {
    var body: some View {
            VStack(alignment: .leading) {
                Text("Activity Tracking")
                    .font(.headline)
                    .fontWeight(.bold)
                HStack{
                    Text("Steps:")
                    Spacer()
                    Text("4,500 / 10,000")
                        .fontWeight(.bold)
                }
                HStack{
                    Text("Heart Rate:")
                    Spacer()
                    Text("78 BPM")
                        .fontWeight(.bold)
                         }
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
    }
}
struct MedicationsSection: View {
    var body: some View {
            VStack(alignment: .leading) {
                Text("Medications")
                .font(.headline)
            MedicationRow(time: "8:00 AM", medication: "Aspirin 81mg")
            MedicationRow(time: "12:00 PM", medication: "Lisinopril 10mg")
            MedicationRow(time: "8:00 PM", medication: "Atorvastatin 20mg")
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

struct MedicationRow: View {
    var time: String
    var medication: String
    var body: some View {
        HStack {
            Text(time)
                .font(.subheadline)
            Spacer()
            Text(medication)
                .font(.subheadline)
        }
    }
}

/* struct AppointmentsSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Appointments")
                .font(.headline)
            AppointmentRow(time: "10:00 AM", description: "Cardiologist Visit")
            AppointmentRow(time: "3:00 PM", description: "Physical Therapy")
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }
}
 */

struct AppointmentRow: View {
    var time: String
    var description: String
    var body: some View {
        HStack {
            Text(time)
                .font(.subheadline)
            Spacer()
            Text(description)
                .font(.subheadline)
        }
    }
}
