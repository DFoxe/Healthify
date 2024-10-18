
import SwiftUI
import Foundation

struct TriageView: View {
    @StateObject private var triageViewModel = TriageViewModel()

    @State private var selectedSex: String? = nil
    @State private var ageInput: String = ""

    struct Symptom: Identifiable, Hashable {
        let id = UUID()
        let symptom_id: String
        let name: String
    }

    private var symptoms = [
        Symptom(symptom_id: "s_98", name: "Fever"),
        Symptom(symptom_id: "s_2100", name: "Fatigue"),
        Symptom(symptom_id: "s_102", name: "Cough"),
        Symptom(symptom_id: "s_21", name: "Headache"),
        Symptom(symptom_id: "s_13", name: "Abdominal pain"),
        Symptom(symptom_id: "s_1190", name: "Back pain"),
        Symptom(symptom_id: "s_44", name: "Joint pain"),
        Symptom(symptom_id: "s_156", name: "Nausea"),
        Symptom(symptom_id: "s_88", name: "Shortness of breath (Dyspnea)"),
        Symptom(symptom_id: "s_8", name: "Diarrhea"),
        Symptom(symptom_id: "s_000", name: "None")
    ]

    @State private var multiSelection = Set<UUID>()



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

                    HStack {
                        Picker("Symptom 1", selection: $triageViewModel.initialEvidence1) {
                            ForEach(symptoms, id: \.self) { symptom in
                                Text(symptom.name).tag(symptom.symptom_id)// Customize this to match your object properties
                            }
                        }
                        Picker("Symptom 2", selection: $triageViewModel.initialEvidence2) {
                            ForEach(symptoms, id: \.self) { symptom in
                                Text(symptom.name).tag(symptom.symptom_id)// Customize this to match your object properties
                            }
                        }
                        Picker("Symptom 3", selection: $triageViewModel.initialEvidence3) {
                            ForEach(symptoms, id: \.self) { symptom in
                                Text(symptom.name).tag(symptom.symptom_id)// Customize this to match your object properties
                            }
                        }
                    }


                // Start triage button
                Button(action: {
                    //Set the age and sex in the ViewModel
                        triageViewModel.beginTriage()
                }) {
                    Text(triageViewModel.age == "" ?  "Please complete all fields" : "Start triage")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(triageViewModel.age == "" ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(triageViewModel.age == "")
                .padding(.horizontal)
            }

            else if triageViewModel.triageStep == 2 && (triageViewModel.userID != nil) {

                if(triageViewModel.isLoading) {

                    Text("Next question loading")
                }
                else if let currQuestion = triageViewModel.currQuestion {
                    Text("\(triageViewModel.currQuestion?.text ?? " ")")

                    if (triageViewModel.currQuestion?.type == "single") {
                        Picker("Select your answer", selection: $triageViewModel.currQuestionAnswer) {
                            Text("Yes").tag("present" as String)
                            Text("No").tag("absent" as String)
                            Text("I don't know").tag("unknown" as String)
                        }.pickerStyle(.segmented)

                        Button(action: {
                            //Set the age and sex in the ViewModel
                            triageViewModel.addEvidence(e: Evidence(id: triageViewModel.currQuestion?.items[0].id ?? " ", name: triageViewModel.currQuestion?.items[0].name,  choice_id: triageViewModel.currQuestionAnswer))
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
                            triageViewModel.addEvidence(e: Evidence(id: triageViewModel.currQuestionAnswer, choice_id: "present"))
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
                        ScrollView {
                            ForEach(triageViewModel.currQuestion?.items.indices ?? 0..<0, id: \.self) { index in
                                if let item = triageViewModel.currQuestion?.items[index] {
                                    Text("\(item.name)")
                                    Picker("Select your answer", selection: Binding(
                                        get: {
                                            triageViewModel.answers[index] ?? "unknown"
                                        },
                                        set: {
                                            triageViewModel.answers[index] = $0
                                        }
                                    )) {
                                        Text("Yes").tag("present" as String)
                                        Text("No").tag("absent" as String)
                                        Text("I don't know").tag("unknown" as String)
                                    }
                                    .pickerStyle(.segmented)
                                }
                            }
                        }
                        Button(action: {
                            // Ensure valid indices before accessing the answers and items
                            if let items = triageViewModel.currQuestion?.items {
                                for (index, answer) in triageViewModel.answers {
                                    if index < items.count {
                                        // Safely retrieve the item at this index
                                        let item = items[index]

                                        // Append each answer to the evidence array as an Evidence object
                                        triageViewModel.addEvidence(e: Evidence(id: item.id, name: item.name, choice_id: answer))
                                    }
                                }
                            }
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

            }

            else if triageViewModel.triageStep == 3 {
                if triageViewModel.isLoading {
                    Text("Fetching final triage")
                }
                else {
                    Text("\(triageViewModel.finalTriage)")
                }
            }

            Spacer()
        }
    }
}
