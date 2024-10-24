

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
    
    @State private var bouncingAnimation: CGFloat = 0
    
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 230/255, green: 244/255, blue: 234/255), Color(red: 255/255, green: 233/255, blue: 227/255)]),startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Logo Button
                    if triageViewModel.triageStep == 0 {
                        VStack {
                            Spacer()
                            Button(action: {
                                triageViewModel.createUser()
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
                            Spacer()
                        }
                    }
                    else if triageViewModel.triageStep == 1 && (triageViewModel.userID != nil) {
                        VStack {
                         Text("Please answer the following questions")
                             .font(.largeTitle)
                             .fontWeight(.bold)
                             .foregroundColor(Color(.black))
                             .padding()
                            
                        // Age Input
                            TextField("Enter your age", text: $ageInput)
                                .keyboardType(.numberPad)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .padding(.horizontal)
                            
                            if let age = Int(ageInput), age < 18 {
                                Text("You must be at least 18 years old to use the triage.")
                                    .foregroundColor(.red)
                                    .padding(.bottom, 5)
                            }
                            
                            // Sex Picker
                            Picker("Select your sex", selection: $triageViewModel.sex) {
                                Text("Male").tag("male" as String?)
                                Text("Female").tag("female" as String?)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            
                            // Description Box
                            Text("Describe your symptoms:")
                                .font(.headline)
                                .padding(.top)
                            
                            TextEditor(text: $triageViewModel.desc)
                                .frame(height: 100)
                                .padding()
                                .background(Color.white)
                                .border(Color.gray, width: 1)
                                .cornerRadius(10)
                                .shadow(radius: 2)
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
                            
                            .padding()

                            // Start triage button
                            Button(action: {
                                //Set the age and sex in the ViewModel
                                if let age = Int(ageInput), age >= 18 {
                                    triageViewModel.age = ageInput
                                    triageViewModel.beginTriage()
                                }
                            }) {
                                Text(ageInput.isEmpty || Int(ageInput) == nil || Int(ageInput) ?? 0 < 18
                                     ?"Please complete all fields" : "Start triage")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(ageInput.isEmpty || Int(ageInput) == nil || Int(ageInput) ?? 0 < 18 ? Color.gray : Color(red: 119/255, green: 189/255, blue: 84/255))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                            .disabled(ageInput.isEmpty || Int(ageInput) == nil || Int(ageInput) ?? 0 < 18)
                            .padding(.horizontal)
                        }
                        .padding()
                    }
        
    
    else if triageViewModel.triageStep == 2 && (triageViewModel.userID != nil) {
                if(triageViewModel.isLoading) {
                            
                            Text("Next question loading")
                                .padding()
                        }
                        else if let currQuestion = triageViewModel.currQuestion {
                            VStack {
                                Spacer()
                                
                                Image("heart.fill") //LOGO
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.red)
                                    .padding(.bottom, 10)
                                
                                Text("Select an answer")
                                    .font(.footnote)
                                    .foregroundColor(Color.gray)
                                    .padding(.top)
                                
                                Text(currQuestion.text) //might cause problems
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(Color.black)
                                    .padding(.vertical)
                                
                                // Text("\(triageViewModel.currQuestion?.text ?? " ")")
                                
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
                                }
                                /* PUT EXTRANEOUS HERE
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                */
                                
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
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                                   .background(Color.white.opacity(0.9))
                                   .cornerRadius(20)
                                   .padding(.horizontal, 20)
                                   .shadow(radius: 10)
                        }
    
                    }
                    else if triageViewModel.triageStep == 3 {
                        if triageViewModel.isLoading {
                            Text("Fetching final triage")
                        }
                        else {
                                ZStack {
                                    VStack {
                                        Spacer()
                                        
                                        if triageViewModel.finalTriage == "Emergency" {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 150, height: 150)
                                                .foregroundColor(.white)
                                                .padding(.bottom, 20)
                                            
                                            Text("Emergency")
                                                .font(.largeTitle)
                                                .foregroundColor(.white)
                                                .padding()
                                            
                                            Button("Find Nearest Emergency Rooms") {
                                                // Navigate to MapView for emergency rooms
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .foregroundColor(.red)
                                            .padding(.bottom, 10)
                                            
                                            Button("Call 911") {
                                                // Trigger phone call to 911
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .foregroundColor(.red)
                                        } else if triageViewModel.finalTriage == "Consultation" {
                                            Image(systemName: "clock.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 150, height: 150)
                                                .foregroundColor(.white)
                                                .padding(.bottom, 20)
                                            
                                            Text("Consultation")
                                                .font(.largeTitle)
                                                .foregroundColor(.white)
                                                .padding()
                                            
                                            Button("Find Nearby Hospitals") {
                                                // Navigate to MapView for hospitals
                                            }
                                            .padding()
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .foregroundColor(.blue)
                                        } else {
                                            Image(systemName: "bandage.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 150, height: 150)
                                                .foregroundColor(.white)
                                                .padding(.bottom, 20)
                                            
                                            Text("Self Care")
                                                .font(.largeTitle)
                                                .foregroundColor(.black)
                                                .padding()
                                        }
                                        
                                        Spacer()
                                    }
                                }
                                .navigationTitle("Result")
                                .navigationBarBackButtonHidden(true)
                                .background(backgroundColor(result: triageViewModel.finalTriage ?? ""))
                                .edgesIgnoringSafeArea(.all)
                            }
                            
                        
                        }
                    }
                        }
                    }
                    
                    Spacer()
                }
    // Function to determine the background color
    private func backgroundColor(result: String) -> Color {
        switch triageViewModel.finalTriage {
        case "Emergency":
            return Color.red.opacity(0.7)
        case "Consultation":
            return Color.blue.opacity(0.3)
        case "Self Care":
            return Color.green.opacity(0.3)
        default:
            return Color.gray.opacity(0.3)
        }
    }
}
        



