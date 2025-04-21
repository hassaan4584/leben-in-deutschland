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
        let questionText = "\(String.random(length: 5)) In Germany, people are allowed to openly say something against the government because ..."
        return Question(num: "Question no 1",
                        question: questionText,
                        a: "freedom of religion applies here. freedom of religion applies here.",
                        b: "people pay taxes.",
                        c: "people have the right to vote.",
                        d: "freedom of expression applies here.",
                        solution: "d",
                        translation: [:],
                        id: .random(length: 10))
    }
    
}

extension String {
    static func random(length: Int) -> String {
        let letters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let characterArr = String((0..<length).hashValue).map { _ in letters.randomElement()! }
        return String(characterArr[0..<length])
    }
}


