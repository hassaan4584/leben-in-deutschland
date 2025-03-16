//
//  QuestionItem.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import Foundation

struct Question: Codable, Identifiable {
    let num: String
    let question: String
    let a: String
    let b: String
    let c: String
    let d: String
    let solution: String
    let translation: [String: Translation]
    let id: String
    
    struct Translation: Codable {
        let question: String
        let a: String
        let b: String
        let c: String
        let d: String
        let context: String
    }
    static func random() -> Question {
        return Question(num: "Question no 1", question: "What is Deutshland?", a: "Option A", b: "Option B", c: "Option C", d: "Option D", solution: "c", translation: [:], id: "someId")
    }
}
