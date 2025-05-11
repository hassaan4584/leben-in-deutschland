//
//  SettingsView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 26.03.25.
//

import SwiftUI

enum AppearanceSetting: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { self.rawValue }
    
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
}


struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var isShareSheetPresented = false
    @AppStorage("appearanceSetting") private var appearanceSetting: AppearanceSetting = .system

    
    var body: some View {
        NavigationStack {
            Form {
                languageSettingsSection
                                appearanceSection
                //                notificationsSection
                aboutInfoSection
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
    
        private var appearanceSection: some View {
            Section {
                Picker("Theme", selection: $appearanceSetting) {
                    Text("System").tag(AppearanceSetting.system)
                    Text("Light").tag(AppearanceSetting.light)
                    Text("Dark").tag(AppearanceSetting.dark)
                }
                .onChange(of: appearanceSetting, initial: true) { _, newValue in
                    setAppearance(newValue)
                }
            } header: {
                Text("Appearance")
            } footer: {
                Text("Configure Dark Mode for the app")
            }
        }
    
    private var aboutInfoSection: some View {
        Section {
            ShareLink(
                item: URL(string: "https://apps.apple.com/app/id6745673617")!,
                message: Text("Here is an app for the preparation of Einbürgerungstests!"),
                preview: SharePreview("Leben In Deutschland")
            ) {
                Label("Share App", systemImage: "square.and.arrow.up")
                    .foregroundStyle(Color.primary)
            }
            Button(action: {
                viewModel.rateApp()
            }) {
                Label("Rate This App", systemImage: "star")
                    .foregroundStyle(Color.primary)
            }
        }
        header: {
            Text("About")
        } footer: {
            Text("Version \(viewModel.appVersion) (\(viewModel.buildNumber))"
            )
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
    
    private func setAppearance(_ setting: AppearanceSetting) {
        // Get all connected scenes
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
        windowScene?.windows.forEach { window in
            window.overrideUserInterfaceStyle = setting.userInterfaceStyle
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
