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
                .tabItem { Text("All Questions") }
                .tag(1)
            Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
            SettingsView()
                .tabItem {
                    TabIconView()
                }
                .tag(3)
        }
    }
}

#Preview {
    TabbarView()
}

struct TabIconView: View {
    var body: some View {
        Text("Settings")
        Image(systemName: "person.circle")
    }
}
