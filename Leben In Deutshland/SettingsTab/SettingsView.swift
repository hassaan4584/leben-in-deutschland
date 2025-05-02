//
//  SettingsView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 26.03.25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        NavigationStack {
            Form {
                languageSettingsSection
                appearanceSection
                notificationsSection
                appInfoSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
            .overlay(loadingOverlay)
            .alert("Settings", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
    
    private var languageSettingsSection: some View {
        Section(header: Text("Language Settings")) {
            Picker("Primary Language", selection: $viewModel.primaryLanguage) {
                ForEach(viewModel.getPrimaryLanguages(), id: \.code) { language in
                    Text(language.name)
                        .tag(language)
                }
            }
            
            Picker("Secondary Language", selection: $viewModel.secondaryLanguage) {
                ForEach(viewModel.getSecondaryLanguages(), id: \.code) { language in
                    Text(language.name)
                        .tag(language)
                }
            }
        }
    }
    
    private var appearanceSection: some View {
        Section(header: Text("Appearance")) {
            Toggle("Dark Mode", isOn: $viewModel.settings.darkModeEnabled)
        }
    }
    
    private var notificationsSection: some View {
        Section(header: Text("Notifications")) {
            Toggle("Enable Notifications", isOn: $viewModel.settings.notificationsEnabled)
        }
    }
    
    private var appInfoSection: some View {
        Section(header: Text("Leben In Deutschland")) {
            HStack {
                Text("Version")
                Spacer()
                Text("\(viewModel.appVersion) (\(viewModel.buildNumber))")
                    .foregroundColor(.gray)
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.saveSettings()
        }) {
            Text("Save")
                .bold()
        }
        .disabled(viewModel.isLoading)
    }
    
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    .scaleEffect(1.5)
            }
        }
    }
}

// Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel:
                        SettingsViewModel(settingsService:
                                            SettingsService()))
    }
}
