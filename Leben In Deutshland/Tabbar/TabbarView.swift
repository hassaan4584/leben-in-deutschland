//
//  TabbarView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 26.03.25.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            QuestionListView()
                .tabItem {
                    TabIconView(title: "All Questions",
                                imageName: "questionmark.circle.fill")
                }
                .tag(1)
            StateQuestionsView(viewModel: .init())
                .tabItem {
                    TabIconView(title: "State Questions",
                                imageName: "flag.circle.fill")
                }
                .tag(2)
            Text("Gallery Tab")
                .tabItem {
                    TabIconView(title: "Gallery",
                                imageName: "house.circle.fill")
                }
                .tag(3)
            SettingsView(viewModel: SettingsViewModel())
                .tabItem {
                    TabIconView(title: "Settings",
                                imageName: "person.circle")
                }
                .tag(4)
        }
        .background(Color.gray.opacity(0.2))
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
