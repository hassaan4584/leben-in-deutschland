//
//  SettingsView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 26.03.25.
//

import SwiftUI

struct SettingsView: View {
    let viewModel: SettingsViewModel
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
            Text("Choose Secondary Language")
            Text("Homepage Questions Language")
        }
    }
}

#Preview {
    SettingsView(viewModel: .init())
}
