//
//  TriageViewModel.swift
//  Healthify
//
//  Created by Guest Damon on 10/5/24.
//

import Foundation

import Combine

class TriageViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var userID: UUID? = nil
    @Published var triageStep: Int = 0
    @Published var age: String = ""
    @Published var sex: String = ""
    @Published var desc: String = "ex: The right side of my head hurts"
    @Published var evidence: [Evidence]? = nil

    var cancellables = Set<AnyCancellable>()

    func continueDiagnosis(){
        // Map Evidence objects to dictionaries
        var evidenceDict : [[String: Any]] = []
        evidence?.forEach { ev in
            print(ev)
            evidenceDict.append( [
                "id": ev.id,
                "choice_id": ev.choice_id,
                "source": ev.source
            ])
        }

        let url = URL(string: "https://api.infermedica.com/v3/diagnosis")!
           var request = URLRequest(url: url)
           request.httpMethod = "POST"

           // Add headers
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.setValue("a7b7c8ec", forHTTPHeaderField: "App-Id")
           request.setValue("1ec19f8845900b07b739d27e211cbe14", forHTTPHeaderField: "App-Key")
           request.setValue(self.userID?.uuidString, forHTTPHeaderField: "Interview-Id")



           let body: [String: Any] = [
            "text": self.desc,
             "age": ["value": self.age],
            "sex": self.sex,
             "evidence": evidenceDict
          ]

            // Convert body to JSON data
            let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData

            // Send the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response as string: \(jsonString)")
                } else {
                    print("Failed to convert data to string")
                }
            }

        task.resume()
    }

    // send over age, sex, symptom description MODIFY TO ACTUALLY TAKE VALUES
    func beginTriage() {
        self.isLoading = true
        
        let url = URL(string: "https://api.infermedica.com/v3/parse")!
           var request = URLRequest(url: url)
           request.httpMethod = "POST"

           // Add headers
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           request.setValue("a7b7c8ec", forHTTPHeaderField: "App-Id")
           request.setValue("1ec19f8845900b07b739d27e211cbe14", forHTTPHeaderField: "App-Key")
           request.setValue(self.userID?.uuidString, forHTTPHeaderField: "Interview-Id")

           // Create the JSON body
           let body: [String: Any] = [
            "text": desc,
            "age": ["value": age],
            "sex": sex
           ]

           // Convert body to JSON data
           let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
           request.httpBody = jsonData

           // Send the request
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               if let error = error {
                   print("Error: \(error.localizedDescription)")
                   return
               }

               guard let data = data else {
                   print("No data received")
                   return
               }

               // Print the response
               do {
                     print(data)
                     let response = try JSONDecoder().decode(DiagnosisAPIResponse.self, from: data)
                     print(response)
                     let evidenceArray: [Evidence] = response.mentions.map { mention in
                         Evidence(id: mention.id, name: mention.name, choice_id: mention.choice_id, source: "predefined")
                     }
                    self.evidence = evidenceArray
                    print(evidenceArray)
                    self.isLoading = false
                   self.continueDiagnosis()
                    self.triageStep = 2
                 } catch {
                     print("Error decoding JSON: \(error)")
                 }
           }



           task.resume()
    }


    //dummy create user function, generates next step of triage, creates UUID
    func createUser() {
        /*guard isValidEmail(email), isValidPhoneNumber(phoneNumber) else {
            errorMessage = "Please enter valid email and phone number."
            return
        }*/
        isLoading = true
        errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            self.isLoading = false
            // call Api to createUser
            print("User created \(self.email)")
            self.userID = UUID()
            self.triageStep += 1

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

