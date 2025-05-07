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
                defaultStateSection
//                appearanceSection
//                notificationsSection
                appInfoSection
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(loadingOverlay)
        }
    }
    
    private var languageSettingsSection: some View {
        Section {
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
        header: {
            Text("Language Settings")
        } footer: {
            Text("'Primary Language' is used to show questions in the questions screen. \n 'Secondary Language' is used to translate questions in the details screen")
        }
    }

    private var defaultStateSection: some View {
//                Section(header: Text("Choose Default State")) {
//                    Picker("Choose default State", selection: $viewModel.defaultState) {
//                        ForEach(viewModel.stateNames, id: \.self) { stateName in
//                            Text(stateName)
//                        }
//                    }
//                }
        
        Section {
            Picker("Choose default State", selection: $viewModel.defaultState) {
                ForEach(viewModel.stateNames, id: \.self) { stateName in
                    Text(stateName)
                }
            }
        }
        header: {
            Text("Choose Default State")
        } footer: {
            Text("The state for which questions would be shown in the 'State Questions' tab")
        }
    }

//    private var appearanceSection: some View {
//        Section(header: Text("Appearance")) {
//            Toggle("Dark Mode", isOn: $viewModel.settings.darkModeEnabled)
//        }

//    }
    
//    private var notificationsSection: some View {
//        Section(header: Text("Notifications")) {
//            Toggle("Enable Notifications", isOn: $viewModel.settings.notificationsEnabled)
//        }
//    }
    
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
