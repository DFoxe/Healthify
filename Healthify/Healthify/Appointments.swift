//
//  Appointments.swift
//  Healthify
//
//  Created by Guest Damon on 7/31/24.
//

import Foundation
import SwiftUI


    struct Appointment: Identifiable{
        let id = UUID()
        var name: String
        var Date: String
        var Time: String
        var Provider: String
    }

struct AppointmentView: View {
    @State private var appointments: [Appointment] = []
    @State private var newDate: String = ""
    @State private var newTime: String = ""
    @State private var newProvider: String = ""

    var body: some View {
        Text("Appointment")
    }
}
