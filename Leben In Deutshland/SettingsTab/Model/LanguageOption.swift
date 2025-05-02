//
//  LanguageOption.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 01.05.25.
//

import Foundation

struct LanguageOption: Codable, Identifiable, Hashable, Comparable {
    
    var id: String { name }
    let code: String
    var name: String
    
    static let english = LanguageOption(code: "en", name: "English")
    static let german = LanguageOption(code: "de", name: "Deutsch")
    
    static let supportedLanguages: [LanguageOption] = [
        english,
        german,
        LanguageOption(code: "fr", name: "French"),
        LanguageOption(code: "tr", name: "Turkish"),
        LanguageOption(code: "ar", name: "Arabic"),
        LanguageOption(code: "uk", name: "Ukraine")
    ]
    
    static func < (lhs: LanguageOption, rhs: LanguageOption) -> Bool {
        lhs.name < rhs.name
    }
    
}
