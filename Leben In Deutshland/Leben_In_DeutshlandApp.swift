//
//  Leben_In_DeutshlandApp.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import SwiftUI

@main
struct Leben_In_DeutshlandApp: App {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color(.systemBackground))
    }
    var body: some Scene {
        WindowGroup {
            TabbarView()
        }
    }
}

#Preview {
    TabbarView()
}
