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
    
    @State private var selectedSex: String? = nil
    @State private var ageInput: String = ""
    
    
    var body: some View {
        VStack(spacing: 40 ) {
            
            //Logo
            Image(systemName: "heart.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColor(Color(red: 0.97, green: 0.42, blue: 0.30))
                .padding(.bottom, 30)
            
            //1: get intial information
            if triageViewModel.triageStep == 0 {
                VStack(spacing: 30) {
                    
                    
                    // Email input
                    HStack {
                        Image(systemName: "envelope.fill").foregroundColor(Color(red: 0.47, green: 0.74, blue: 0.33))
                        TextField("Enter your email", text: $triageViewModel.email)
                            .padding()
                            .font(.system(size:18, weight: .medium))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.47, green: 0.74, blue: 0.33), lineWidth: 2))
                    }
                    .padding(.horizontal, 20)
                    
                    //Phone Number
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(Color(red: 0.47, green: 0.74, blue: 0.33))
                        TextField("Enter your phone number", text: $triageViewModel.phoneNumber)
                            .padding()
                            .font(.system(size: 18, weight: .medium))
                            .keyboardType(.phonePad)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red:0.47, green: 0.74, blue: 0.33), lineWidth: 2))
                    }
                    .padding(.horizontal, 20)
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
            }
                else if triageViewModel.triageStep == 1 && (triageViewModel.userID != nil) {
                    // Age Input
                    TextField("Enter your age", text: $triageViewModel.age)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    // Sex Picker
                    Picker("Select your sex", selection: $triageViewModel.sex) {
                        Text("Male").tag("male" as String?)
                        Text("Female").tag("female" as String?)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // Description Box
                    Text("Describe your symptoms:")
                        .font(.headline)
                        .padding(.top)
                    
                    TextEditor(text: $triageViewModel.desc)
                        .frame(height: 150)
                        .padding()
                        .border(Color.gray, width:1)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    //Error handling for empty fields
                    if selectedSex == nil || ageInput.isEmpty {
                        Text("Please fill in all fields")
                            .foregroundColor(.red)
                    }
                    
                    // Start triage button
                    Button(action: {
                        //Set the age and sex in the ViewModel
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
                    
                    if let evidence = triageViewModel.evidence {
                        Text("Evidence: \(evidence)")
                    } else{
                        Text("No evidence collected")
                    }
                }
                Spacer()
            }
        }
    }

