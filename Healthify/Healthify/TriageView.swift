//
//  TriageView.swift
//  Healthify
//
//  Created by Guest Damon on 9/29/24.
//

import SwiftUI
import Foundation

struct TriageView: View {
    @StateObject private var triageViewModel = TriageViewModel()

    var body: some View {
        VStack(spacing: 20 ) {

            //1: get intial information
            if triageViewModel.triageStep == 0 {
                // Email input
                TextField("Enter your email", text: $triageViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()

                //Phone Number
                TextField("Enter your phone number", text: $triageViewModel.phoneNumber)
                    .keyboardType(.phonePad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                //Error
                if let errorMessage = triageViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.horizontal)
                }

                //Submit and start Triage
                Button(action: {
                    triageViewModel.createUser()
                }) {
                    Text(triageViewModel.isLoading ? "Creating User..." : "Create User")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(triageViewModel.isLoading ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(triageViewModel.isLoading)
                .padding(.horizontal)
            }

            else if triageViewModel.triageStep == 1 && (triageViewModel.userID != nil) {
                Text("Now more info here")
                Text("Default vals: \n\nMale \n28 \n'My stomach hurts'")

                Button(action: {
                    triageViewModel.beginTriage()
                }) {
                    Text(triageViewModel.isLoading ? "Gathering symptoms..." : "Start triage")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(triageViewModel.isLoading ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(triageViewModel.isLoading)
                .padding(.horizontal)
            }

            else if triageViewModel.triageStep == 2 && (triageViewModel.userID != nil) {
                Text("Profile")
                Text("age: \(triageViewModel.age) sex: \(triageViewModel.sex)")

                Text("\(triageViewModel.evidence)")

            }




            Spacer()
        }
    }
}
