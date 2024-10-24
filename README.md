Healthify
Healthify is an iOS app built using Swift and SwiftUI, designed to assist users with medical triage, guiding them through symptom selection and providing a recommendation based on their inputs.

Features
Symptom-based triage system
Provides recommendations like 'Emergency,' 'Consultation,' or 'Self Care'
User-friendly design with customizable color themes
Requirements
Xcode 14.0 or later
iOS 15.0 or later
An Infermedica API account to retrieve appid and appkey (get one at Infermedica)
Installation
Clone the repository:

bash
Copy code
git clone https://github.com/yourusername/healthify.git
cd healthify
Open the project in Xcode:

bash
Copy code
open Healthify.xcodeproj
Configure the app:

In the HomeView(), comment out the line for TestTriageView() and uncomment TriageView():

swift
Copy code
// TestTriageView() // Comment this out
TriageView() // Uncomment this
Navigate to TriageViewModel.swift and set your own appid and appkey by replacing the placeholder values with the keys from your Infermedica developer account:

swift
Copy code
private var appid = "your-app-id-here"
private var appkey = "your-app-key-here"
Run the app:

Press Cmd + R or hit the play button in Xcode to build and run the app on a simulator or connected device.

Contributing
If you wish to contribute to Healthify, feel free to submit a pull request or report any issues.
