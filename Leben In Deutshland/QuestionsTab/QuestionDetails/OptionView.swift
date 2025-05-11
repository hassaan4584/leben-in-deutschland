//
//  OptionView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import SwiftUI

enum OptionState {
    case notSelected
    case selected(Bool)
}
class OptionViewModel: ObservableObject {
    let translatedQuestion: String
    // TODO: use `OptionState` instead of Bool flags
    let isSelected: Bool
    let isCorrect: Bool?

    init(translatedQuestion: String, isSelected: Bool, isCorrect: Bool?) {
        self.translatedQuestion = translatedQuestion
        self.isSelected = isSelected
        self.isCorrect = isCorrect
    }
}

struct OptionView: View {
    var isCorrect: Bool? { viewModel.isCorrect }
    var isSelected: Bool { viewModel.isSelected }
    let viewModel: OptionViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: getChecboxIcon())
                .foregroundColor(getCheckboxColor())
                .background( Circle()
                    .fill(.clear)
                )
            Text(viewModel.translatedQuestion)
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
            return isCorrect == true ? "checkmark.circle.fill" : "xmark.circle.fill"
        } else {
            return "circle"
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
    let optionViewModel = OptionViewModel(translatedQuestion:  "This is a Question",
                                          isSelected: true,
                                          isCorrect: false)
    VStack(alignment: .leading, spacing: 10) {
        
        OptionView(viewModel: optionViewModel)
        
        OptionView(viewModel: .init(translatedQuestion: "This is Correct Answer", isSelected: true, isCorrect: true))

        OptionView(viewModel: .init(translatedQuestion: "This is unselected Question", isSelected: false, isCorrect: nil))
    }
}
