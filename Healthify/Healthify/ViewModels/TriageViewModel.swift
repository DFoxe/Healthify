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
    @Published var initialEvidence1: String = "s_000"
    @Published var initialEvidence2: String = "s_000"
    @Published var initialEvidence3: String = "s_000"
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
    @Published var answers: [Int: String] = [:]
    @Published var finalTriage: String? = nil
    private var appid: String = ""
    private var appkey: String = ""
    
    
    var cancellables = Set<AnyCancellable>()


    func finalTriage(evidence: [[String: Any]]) {

        let url = URL(string: "https://api.infermedica.com/v3/triage")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.appid, forHTTPHeaderField: "App-Id")
        request.setValue(self.appkey, forHTTPHeaderField: "App-Key")
        request.setValue(self.userID?.uuidString, forHTTPHeaderField: "Interview-Id")

        let body: [String: Any] = [
            "text": self.desc,
            "age": ["value": Int(self.age)],
            "sex": self.sex ?? "male",
            "evidence": evidence
        ]

        print("SENDING: ", body)

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
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("final triage response: ", jsonString) // This will print the JSON as a string
                } else {
                    print("Failed to convert data to string.")
                }
                let response = try JSONDecoder().decode(TriageAPIResponse.self, from: data)

                DispatchQueue.main.async {
                    self.finalTriage = response.triage_level
                    print(self.finalTriage)
                    self.isLoading = false
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        task.resume()
    }

    func submitDiagnosis(){
        self.isLoading = true
        continueDiagnosis()
    }

    func continueDiagnosis(){
        DispatchQueue.main.async {
            self.isLoading = true
        }

        var evidenceDict : [[String: Any]] = []
        evidence?.forEach { ev in
            print(ev)
            evidenceDict.append( [
                "id": ev.id,
                "choice_id": ev.choice_id,
                "source": ev.source
            ])
        }

        if self.should_stop_triage {
            self.isLoading = true
            self.triageStep = 3
            self.finalTriage(evidence: evidenceDict)
        }


                let url = URL(string: "https://api.infermedica.com/v3/diagnosis")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"

                // Add headers
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(self.appid, forHTTPHeaderField: "App-Id")
                request.setValue(self.appkey, forHTTPHeaderField: "App-Key")
                request.setValue(self.userID?.uuidString, forHTTPHeaderField: "Interview-Id")

                let body: [String: Any] = [
                    "text": self.desc,
                    "age": ["value": Int(self.age)],
                    "sex": self.sex ?? "male",
                    "evidence": evidenceDict
                ]

                print("SENDING: ", body)

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
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("diagnosis: ", jsonString) // This will print the JSON as a string
                        } else {
                            print("Failed to convert data to string.")
                        }

                        let response = try JSONDecoder().decode(QuestionsAPIResponse.self, from: data)

                        DispatchQueue.main.async {
                            self.currQuestion = response.question
                            self.should_stop_triage = response.should_stop ?? false
                            print(response.question.text, response.should_stop)
                            if response.question.type == "group_single" {
                                self.currQuestionAnswer = String(response.question.items[0].id)
                            } else {
                                self.currQuestionAnswer = "unknown"
                            }
                            self.isLoading = false
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }

                task.resume()
            }
        //}

    // send over age, sex, symptom description MODIFY TO ACTUALLY TAKE VALUES
    func beginTriage() {

        self.isLoading = true

        let url = URL(string: "https://api.infermedica.com/v3/parse")!
           var request = URLRequest(url: url)
           request.httpMethod = "POST"

           // Add headers
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(self.appid, forHTTPHeaderField: "App-Id")
            request.setValue(self.appkey, forHTTPHeaderField: "App-Key")
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
                         Evidence(id: mention.id, name: mention.name, choice_id: mention.choice_id, source: "initial")
                     }
                    self.evidence = evidenceArray
                    if(self.initialEvidence1 != "s_000"){
                        self.evidence?.append(Evidence(id: self.initialEvidence1, choice_id: "present", source: "initial"))
                    }
                   if(self.initialEvidence2 != "s_000"){
                       self.evidence?.append(Evidence(id: self.initialEvidence2, choice_id: "present", source: "initial"))
                   }
                   if(self.initialEvidence3 != "s_000"){
                       self.evidence?.append(Evidence(id: self.initialEvidence3, choice_id: "present", source: "initial"))
                   }
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

