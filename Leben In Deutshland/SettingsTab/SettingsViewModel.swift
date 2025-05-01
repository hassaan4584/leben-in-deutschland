//
//  SettingsViewModel.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 23.04.25.
//

import Foundation

struct SettingsViewModel {
    private let appSettings: AppSettings
    
    init(appSettings: AppSettings = AppSettingsImplementation()) {
        self.appSettings = appSettings
    }
}

