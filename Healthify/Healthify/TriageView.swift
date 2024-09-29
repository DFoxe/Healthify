//
//  TriageView.swift
//  Healthify
//
//  Created by Guest Damon on 9/29/24.
//

import SwiftUI

struct TriageView: View {
    @StateObject private var triageViewModel = TriageViewModel()
    
    var body: some View {
        VStack(spacing: 20 ) {
            
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
                Text(triageViewModel.isLoading ? "Creating User..." : "Start Triage")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(triageViewModel.isLoading ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(triageViewModel.isLoading)
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

import Combine

class TriageViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var cancellables = Set<AnyCancellable>()
    
    func createUser() {
        guard isValidEmail(email), isValidPhoneNumber(phoneNumber) else {
            errorMessage = "Please enter valid email and phone number."
            return
        }
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.isLoading = false
            // call Api to createUser
            print("User created")
        }
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za=z]{2,64}"
        let emailPredicate = NSPredicate(format: "Self Matches %@", emailRegEx)
        return emailPredicate.evaluate(with:email)
    }
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegEx = "^[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePredicate.evaluate(with: phoneNumber)
    }
}


