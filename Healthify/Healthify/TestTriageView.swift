//
//  TestTriageView.swift
//  Healthify
//
//  Created by Guest Damon on 10/20/24.
//

import Foundation
import SwiftUI

struct TestTriageView: View {
    // Mocked data for testing
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var ageInput: String = ""
    @State private var selectedSex: String? = "male"
    @State private var descriptionText: String = ""
    @State private var symptom1: String = "s_98"
    @State private var symptom2: String = "s_2100"
    @State private var symptom3: String = "s_102"
    
    // State to track current step
    @State private var currentStep: Int = 0
    
    // State to track the response for the mock question
    @State private var selectedResponse: String? = nil
    @State private var resultPage: String? = nil // For navigation to result page
    
    private var symptoms = [
        Symptom(symptom_id: "s_98", name: "Fever"),
        Symptom(symptom_id: "s_2100", name: "Fatigue"),
        Symptom(symptom_id: "s_102", name: "Cough"),
        Symptom(symptom_id: "s_21", name: "Headache"),
        Symptom(symptom_id: "s_13", name: "Abdominal pain"),
        Symptom(symptom_id: "s_1190", name: "Back pain"),
        Symptom(symptom_id: "s_44", name: "Joint pain"),
        Symptom(symptom_id: "s_156", name: "Nausea"),
        Symptom(symptom_id: "s_88", name: "Shortness of breath"),
        Symptom(symptom_id: "s_8", name: "Diarrhea"),
        Symptom(symptom_id: "s_000", name: "None")
    ]
    
    @State private var bouncingAnimation: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 230/255, green: 244/255, blue: 234/255), Color(red: 255/255, green: 233/255, blue: 227/255)]),startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    // Logo Button
                    if currentStep == 0 {
                        VStack {
                            Button(action: {
                                currentStep += 1
                            }) {
                                Image(systemName: "heart.fill") // Using the default heart image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150) // Adjust the size as needed
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
                            // Bouncing arrow pointing at the heart
                            Image(systemName: "arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                                .offset(y: bouncingAnimation)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                        bouncingAnimation = 10
                                    }
                                }
                            
                            // Start Triage Text
                            Text("Touch to Start Triage")
                                .font(.title)
                                .foregroundColor(.green)
                                .offset(y: bouncingAnimation)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                        bouncingAnimation = 10
                                    }
                                }
                        }
                    }
                    // Step 2: Age and Sex Selection
                    else if currentStep == 1 {
                        VStack {
                            Text("Please answer the following questions")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.black))
                                .padding()
                            
                            TextField("Enter your age", text: $ageInput)
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .padding(.horizontal)
                            
                            Picker("Select your sex", selection: $selectedSex) {
                                Text("Male").tag("male" as String?)
                                Text("Female").tag("female" as String?)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            
                            Text("Describe your symptoms:")
                                .font(.headline)
                                .padding(.top)
                            
                            TextEditor(text: $descriptionText)
                                .frame(height: 100)
                                .padding()
                                .background(Color.white)
                                .border(Color.gray, width: 1)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .padding(.horizontal)
                            
                            HStack {
                                Picker("Symptom 1", selection: $symptom1) {
                                    ForEach(symptoms, id: \.symptom_id) { symptom in
                                        Text(symptom.name).tag(symptom.symptom_id)
                                    }
                                }
                                Picker("Symptom 2", selection: $symptom2) {
                                    ForEach(symptoms, id: \.symptom_id) { symptom in
                                        Text(symptom.name).tag(symptom.symptom_id)
                                    }
                                }
                                Picker("Symptom 3", selection: $symptom3) {
                                    ForEach(symptoms, id: \.symptom_id) { symptom in
                                        Text(symptom.name).tag(symptom.symptom_id)
                                    }
                                }
                            }
                            .padding()
                            
                            Button(action: {
                                // Move to the next step
                                currentStep += 1
                            }) {
                                Text("Next")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 119/255, green: 189/255, blue: 84/255)) // #F86C4C
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                    
                    // Step 3: Mock Question
                    else if currentStep == 2 {
                        ScrollView {
                            VStack(spacing: 20) {
                                Text("Is your headache mild?")
                                    .font(.headline)
                                    .padding()
                                
                                HStack {
                                    Button("Yes") {
                                        selectedResponse = "Yes"
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedResponse == "Yes" ? Color.green : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    
                                    Button("No") {
                                        selectedResponse = "No"
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedResponse == "No" ? Color.green : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    
                                    Button("I don't know") {
                                        selectedResponse = "I don't know"
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedResponse == "I don't know" ? Color.green : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .padding()
                                
                                // Submit Button
                                Button(action: {
                                    // Determine the result page based on the selected response
                                    if selectedResponse == "Yes" {
                                        resultPage = "Emergency"
                                    } else if selectedResponse == "No" {
                                        resultPage = "Consultation"
                                    } else {
                                        resultPage = "Self Care"
                                    }
                                }) {
                                    Text("Submit")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding()
                            }
                        }
                        .navigationTitle("Question")
                    }
                    
                    // Result Page
                    if let resultPage = resultPage {
                        NavigationLink(destination: ResultPage(result: resultPage)) {
                            Text("Go to Result Page")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                }
                .padding()
            }
        }
    }
    
    struct Symptom: Identifiable {
        let id = UUID()
        let symptom_id: String
        let name: String
    }
    
    struct ResultPage: View {
        let result: String
        
        var body: some View {
            VStack {
                Text("Your Triage Result")
                    .font(.largeTitle)
                    .padding()
                
                Text(result)
                    .font(.title)
                    .padding()
                
                // Additional content based on result can go here
            }
            .navigationTitle("Result")
        }
    }
}
struct TestTriageView_Previews: PreviewProvider {
    static var previews: some View {
        TestTriageView()
    }
}
