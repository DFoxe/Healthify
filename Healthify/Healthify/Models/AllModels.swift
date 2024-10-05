//
//  AllModels.swift
//  Healthify
//
//  Created by Guest Damon on 8/7/24.
//

import Foundation
import SwiftUI

struct question: Codable{
        var question: String
        var answer_type: String
        var answers: [String]
        var answerIds: [String]
}
struct answer: Codable{
    var id: String
    var name: String
    var common_name: String
    var probability: Int
    var rating: String
    var icd10: [Int]
    var condition_details: String
    var explain: String
    var patient_education: String
}

struct triage{
    var level: String
    var description: String
    var serious:[String]
}

struct Evidence: Codable{
    var id: String
    var name: String
    var choice_id: String
    var source: String
}

struct Mention: Codable {
    var id: String
    var name: String
    var choice_id: String
}

struct DiagnosisAPIResponse: Codable {
    var mentions: [Mention]
    var obvious: Bool
}

