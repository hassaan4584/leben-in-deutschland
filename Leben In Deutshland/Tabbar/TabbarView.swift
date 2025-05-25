//
//  TabbarView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 26.03.25.
//

import SwiftUI

struct TabbarView: View {
    @ObservedObject var viewModel = TabbarViewModel()
    var body: some View {
        TabView(selection: $viewModel.selectedTabIndex) {
            HomeView()
                .tabItem {
                    TabIconView(title: "Home",
                                imageName: "house.circle.fill")
                }
                .tag(0)
            QuestionsListView()
                .tabItem {
                    TabIconView(title: "All Questions",
                                imageName: "questionmark.circle.fill")
                }
                .tag(1)
            NavigationStack {
                StateQuestionsView(viewModel: .init())
            }
                .tabItem {
                    TabIconView(title: "State Questions",
                                imageName: "flag.circle.fill")
                }
                .tag(2)
            NavigationStack {
                SettingsView(viewModel: SettingsViewModel())
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(5)
        }
//        .background(Color(.systemGroupedBackground))
//        .toolbarBackground(UIColor(Color(.systemBackground)), for: .tabBar) // Set custom color
//        .toolbarBackground(Color(.systemBackground), for: .tabBar)
        .toolbarBackground(Color(.red), for: .tabBar)
    }
}

#Preview {
    TabbarView()
}

struct TabIconView: View {
    private let title: String
    private let imageName: String
    
    init(title: String = "", imageName: String = "") {
        self.title = title
        self.imageName = imageName
    }

    var body: some View {
        Text(title)
        Image(systemName: imageName)
    }
}
