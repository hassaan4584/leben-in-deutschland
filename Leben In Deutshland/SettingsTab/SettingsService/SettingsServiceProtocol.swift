//
//  SettingsServiceProtocol.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 01.05.25.
//

import Foundation
import Combine

protocol SettingsServiceProtocol {
    func loadSettings() -> AnyPublisher<AppSettings, Error>
    func saveSettings(_ settings: AppSettings) -> AnyPublisher<Void, Error>
}

