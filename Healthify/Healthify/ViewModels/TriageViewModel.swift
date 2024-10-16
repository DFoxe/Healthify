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
    @Published var sex: String? = "male"
    @Published var desc: String = "ex: The right side of my head hurts"
    @Published var evidence: [Evidence]? = nil
    @Published var should_stop_triage: Bool = false
    @Published var currQuestion: Question? = nil
    @Published var currQuestionAnswer: String = "unkown"
    @Published var currQuestionAnswered: Bool? = nil

    var cancellables = Set<AnyCancellable>()

    func submitDiagnosis(){
        continueDiagnosis()
    }

    func continueDiagnosis(){

        //while !should_stop_triage {
            // Map Evidence objects to dictionaries
            var evidenceDict : [[String: Any]] = []
            evidence?.forEach { ev in
                print(ev)
                evidenceDict.append( [
                    "id": ev.id,
                    "choice_id": ev.choice_id,
                    "source": ev.source
                ])


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
                    "age": ["value": Int(self.age)],
                    "sex": self.sex ?? "male",
                    "evidence": evidenceDict
                ]

                // Convert body to JSON data
                let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = jsonData
                print("SENDING THIS BODY: \(jsonData)")

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
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print(jsonString) // This will print the JSON as a string
                        } else {
                            print("Failed to convert data to string.")
                        }
                        let response = try JSONDecoder().decode(QuestionsAPIResponse.self, from: data)

                        if response.question.type == "group_single" {
                            DispatchQueue.main.async {
                                self.currQuestionAnswer = String(response.question.items[0].id)
                                print(self.currQuestionAnswer)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.currQuestionAnswer = "uknown"
                                print(self.currQuestionAnswer)
                            }
                            
                        }
                        self.currQuestion = response.question

                        /* let evidenceArray: [Evidence] = response.mentions.map { mention in
                         Evidence(id: mention.id, name: mention.name, choice_id: mention.choice_id, source: "predefined")
                         }
                         self.evidence = evidenceArray
                         print(evidenceArray)
                         self.isLoading = false
                         self.continueDiagnosis()
                         self.triageStep = 2*/
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }

                task.resume()
            }
        //}
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
            "text": self.desc,
            "age": ["value": Int(self.age)],
            "sex": self.sex ?? "male"
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
                       if let jsonString = String(data: data, encoding: .utf8) {
                           print(jsonString) // This will print the JSON as a string
                       } else {
                           print("Failed to convert data to string.")
                       }
                     let response = try JSONDecoder().decode(DiagnosisAPIResponse.self, from: data)
                     print(response)
                     let evidenceArray: [Evidence] = response.mentions.map { mention in
                         Evidence(id: mention.id, name: mention.name, choice_id: mention.choice_id, source: "suggest")
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

    func addEvidence(e: Evidence){
        self.evidence?.append(e)
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

