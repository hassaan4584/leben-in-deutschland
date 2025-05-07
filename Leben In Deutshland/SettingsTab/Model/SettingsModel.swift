//
//  SettingsModel.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 01.05.25.
//

import Foundation

struct AppSettings: Codable {
    var primaryLanguageStr: String
    var primaryLanguage: LanguageOption
    var secondaryLanguage: LanguageOption
    var defaultState: String
    var notificationsEnabled: Bool
    var darkModeEnabled: Bool
    
    static let `default` = AppSettings(
        primaryLanguageStr: "English",
        primaryLanguage: LanguageOption.german,
        secondaryLanguage: LanguageOption.english,
        defaultState: "Berlin",
        notificationsEnabled: true,
        darkModeEnabled: false
    )
}
