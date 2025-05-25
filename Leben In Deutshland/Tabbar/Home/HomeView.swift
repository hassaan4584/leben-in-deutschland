//
//  HomeView.swift
//  Leben In Deutschland
//
//  Created by Hassaan Ahmed on 10.05.25.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel = HomeViewModel()
    var body: some View {
        CardNavigationView()
    }
}

#Preview {
    HomeView()
}


struct CardNavigationView: View {

    let cards: [CardData] = [.init(title: "General Questions", icon: "questionmark.app.fill", color: .blue, subtitle: "List of 300 General Questions", navigationType: .generalQuestions),
                             .init(title: "State Questions", icon: "questionmark.app.fill", color: .blue, subtitle: "Questions specific to the State you live in", navigationType: .stateQuestions),
                             .init(title: "Saved Questions", icon: "bookmark.fill", color: .green, subtitle: "Recap marked questions", navigationType: .savedQuestions),
                             .init(title: "Settings", icon: "gearshape.fill", color: .green, subtitle: "Configure app preferences", navigationType: .settings),
                             .init(title: "Reminders", icon: "bell.fill", color: .orange, subtitle: "Coming soon", navigationType: .reminders),
                             .init(title: "Practise Test", icon: "pencil.and.scribble", color: .orange, subtitle: "Coming soon", navigationType: .practiceTest)
]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Create rows of 2 cards each
                    ForEach(Array(stride(from: 0, to: cards.count, by: 2)), id: \.self) { index in
                        HStack(alignment: .top, spacing: 16) {
                            // First card in the row
                            if index < cards.count {
                                NavigationLink {
                                    destinationView(for: cards[index].navigationType)
                                } label: {
                                    HomeCardView(cardData: cards[index])
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Second card in the row
                            if index + 1 < cards.count {
                                NavigationLink {
                                    destinationView(for: cards[index + 1].navigationType)
                                } label: {
                                    HomeCardView(cardData: cards[index + 1])
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Dashboard")
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Helper function to determine destination view
    @ViewBuilder
    private func destinationView(for navigationType: CardData.CardNavigationType) -> some View {
        switch navigationType {
        case .generalQuestions: QuestionsListView(viewModel: .init())
        case .stateQuestions: StateQuestionsView(viewModel: .init())
        case .savedQuestions: QuestionsListView()
        case .settings: SettingsView(viewModel: .init())
        case .practiceTest: Text("Functionality to take practise \ntests is coming soon...")
        case .reminders: Text("Reminders functionality is coming soon...")
        }
    }
}
