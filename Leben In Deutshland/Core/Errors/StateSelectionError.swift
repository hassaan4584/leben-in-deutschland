//
//  StateSelectionError.swift
//  Leben In Deutschland
//
//  Created by Hassaan Ahmed on 09.05.25.
//

import Foundation

enum StateSelectionError: Error {
    case noQuestionsAvailable
    case unableToReadQuestionsFile
    case unknown

    var localizedDescription: String {
        switch self {
        case .noQuestionsAvailable:
            return "No questions available"
        case .unableToReadQuestionsFile:
            return "Unable to read questions file"
        case .unknown:
            return "Some unknown error occurred"
        }
    }
}
