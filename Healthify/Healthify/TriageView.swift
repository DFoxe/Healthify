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
                Text("\(triageViewModel.currQuestion?.text ?? " ")")

                if (triageViewModel.currQuestion?.type == "single") {
                    Picker("Select your answer", selection: $triageViewModel.currQuestionAnswer) {
                        Text("Yes").tag("present" as String)
                        Text("No").tag("absent" as String)
                        Text("I don't know").tag("unkown" as String)
                    }.pickerStyle(.segmented)

                    Button(action: {
                        //Set the age and sex in the ViewModel
                        triageViewModel.addEvidence(e: Evidence(id: triageViewModel.currQuestion?.items[0].id ?? " ", choice_id: triageViewModel.currQuestionAnswer, source: "initial"))
                        triageViewModel.submitDiagnosis()
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(triageViewModel.isLoading ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                }
                else if (triageViewModel.currQuestion?.type == "group_single") {
                    Picker("Select your answer", selection: $triageViewModel.currQuestionAnswer) {
                        ForEach(triageViewModel.currQuestion?.items.indices ?? 0..<0, id: \.self) { index in
                            if let item = triageViewModel.currQuestion?.items[index] {
                                Text("\(item.name)").tag(item.id as String)
                            }
                        }
                    }

                    Button(action: {
                        //Set the age and sex in the ViewModel
                        print("\(triageViewModel.currQuestionAnswer)")
                        triageViewModel.addEvidence(e: Evidence(id: triageViewModel.currQuestionAnswer, choice_id: "present", source: "initial"))
                        triageViewModel.submitDiagnosis()
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(triageViewModel.isLoading ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                }
                else {
                    ForEach(triageViewModel.currQuestion?.items.indices ?? 0..<0, id: \.self) { index in
                        if let item = triageViewModel.currQuestion?.items[index] {
                            Text("\(item.name)")
                            Picker("Select your answer", selection: $triageViewModel.currQuestionAnswer) {
                                Text("Yes").tag("present" as String)
                                Text("No").tag("absent" as String)
                                Text("I don't know").tag("unkown" as String)
                            }.pickerStyle(.segmented)

                            Button(action: {
                                triageViewModel.addEvidence(e: Evidence(id: triageViewModel.currQuestion?.items[0].id ?? " ", choice_id: triageViewModel.currQuestionAnswer, source: "initial"))
                            }) {
                                Text("Submit")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(triageViewModel.isLoading ? Color.gray : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    Button(action: {
                        triageViewModel.submitDiagnosis()
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(triageViewModel.isLoading ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                }
            }
            Spacer()
        }
    }
}
