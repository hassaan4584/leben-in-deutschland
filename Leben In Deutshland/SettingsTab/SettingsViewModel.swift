//
//  SettingsViewModel.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 23.04.25.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings {
        didSet {
            saveSettings()
        }
    }
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var primaryLanguage: LanguageOption = AppSettings.default.primaryLanguage {
        didSet {
            settings.primaryLanguage = primaryLanguage
        }
    }
    
    @Published var secondaryLanguage: LanguageOption = AppSettings.default.secondaryLanguage {
        didSet {
            settings.secondaryLanguage = secondaryLanguage
        }
    }

    private let settingsService: SettingsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(settingsService: SettingsServiceProtocol = SettingsService()) {
        self.settingsService = settingsService
        self.settings = AppSettings.default
        loadSettings()
    }

    func getPrimaryLanguages() -> [LanguageOption] {
        var allLanguages: Set<LanguageOption> = Set.init(LanguageOption.supportedLanguages)
        allLanguages.remove(secondaryLanguage)
        return allLanguages.sorted()
    }
    
    func getSecondaryLanguages() -> [LanguageOption] {
        var allLanguages: Set<LanguageOption> = Set.init(LanguageOption.supportedLanguages)
        allLanguages.remove(primaryLanguage)
        return allLanguages.sorted()
    }
    
    
    func loadSettings() {
        isLoading = true
        settingsService.loadSettings()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            } receiveValue: { [weak self] loadedSettings in
                self?.settings = loadedSettings
                self?.primaryLanguage = loadedSettings.primaryLanguage
                self?.secondaryLanguage = loadedSettings.secondaryLanguage
            }
            .store(in: &cancellables)
    }
    
    func saveSettings() {
        isLoading = true
        settingsService.saveSettings(settings)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            } receiveValue: { _ in
                print("Settings Saved")
            }
            .store(in: &cancellables)
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

