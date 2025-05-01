//
//  OptionView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import SwiftUI

struct OptionView: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let correctAnswer: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: getChecboxIcon())
                .foregroundColor(getCheckboxColor())
            Text(text)
                .foregroundColor(getTextColor())
                .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
        .background(getBackgroundColor())
        .cornerRadius(8)
        
    }
    
    private func getChecboxIcon() -> String {
        if isSelected {
            return isCorrect == true ? "checkmark.square.fill" : "xmark.square.fill"
        } else {
            return "square"
        }
    }
    private func getCheckboxColor() -> Color {
        if isSelected {
            return isCorrect == true ? .green : .red
        }
        return .primary
    }
    
    private func getTextColor() -> Color {
        if isSelected {
            return isCorrect == true ? .green : .red
        }
        return .primary
    }
    
    private func getBackgroundColor() -> Color {
        if isSelected {
            return isCorrect == true ? Color.green.opacity(0.1) : Color.red.opacity(0.1)
        }
        return Color.gray.opacity(0.2)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 10) {
        
        OptionView(text: "This is some Question", isSelected: false, isCorrect: false, correctAnswer: "b")
        
        OptionView(text: "This is some Question with a very very long text that is going to go into multiple lines. Freedom of press is also a fundamental right which cannot be abolished", isSelected: true, isCorrect: true, correctAnswer: "b")
    }
}
