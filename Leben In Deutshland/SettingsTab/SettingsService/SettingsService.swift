//
//  SettingsService.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 01.05.25.
//

import Foundation
import Combine

class SettingsService: SettingsServiceProtocol {
    private let userDefaults: KeyValueStoring
    private let settingsKey = "appSettingsKey"
    
    init(userDefaults: KeyValueStoring = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func loadSettings() -> AnyPublisher<AppSettings, Error> {
        Future<AppSettings, Error> { [weak self] promise in
            guard let self = self else { return }
            
            if let data: Data = self.userDefaults.value(for: self.settingsKey) ,
               let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
                    promise(.success(settings))
            } else {
                promise(.success(AppSettings.default))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveSettings(_ settings: AppSettings) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            
            do {
                let data = try JSONEncoder().encode(settings)
                self.userDefaults.setValue(data, for: self.settingsKey)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}


// Services/MockSettingsService.swift
class MockSettingsService: SettingsServiceProtocol {
    var mockSettings = AppSettings.default
    
    func loadSettings() -> AnyPublisher<AppSettings, Error> {
        Just(mockSettings)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func saveSettings(_ settings: AppSettings) -> AnyPublisher<Void, Error> {
        mockSettings = settings
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
