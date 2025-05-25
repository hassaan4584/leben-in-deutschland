//
//  HomeCardView.swift
//  Leben In Deutschland
//
//  Created by Hassaan Ahmed on 25.05.25.
//

import SwiftUI

struct CardData: Hashable {
    let title: String
    let icon: String
    let color: Color
    let subtitle: String
    let navigationType: CardNavigationType

    enum CardNavigationType: String {
        case generalQuestions
        case stateQuestions
        case reminders
        case practiceTest
        case savedQuestions
        case settings
    }
    
    init(title: String, icon: String, color: Color, subtitle: String, navigationType: CardNavigationType) {
        self.title = title
        self.icon = icon
        self.color = color
        self.subtitle = subtitle
        self.navigationType = navigationType
    }
}

struct HomeCardView: View {
    
    let cardData: CardData
    init(cardData: CardData) {
        self.cardData = cardData
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Image(systemName: cardData.icon)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    .background(cardData.color.gradient)
                    .cornerRadius(5)
                
                Text(cardData.title)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.primary)
                
                Spacer()
                
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
            }

            Text(cardData.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
        }
        .padding([.top, .bottom, .trailing])
        .padding([.leading], 8 )
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    let card: CardData = .init(title: "General Questions", icon: "questionmark.app.fill", color: .blue, subtitle: "List of 300 General Questions", navigationType: .generalQuestions)

    HomeCardView(cardData: card)
}
