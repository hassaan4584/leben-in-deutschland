//
//  QuestionDetailView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import SwiftUI

import SwiftUI
import SwiftUI

struct QuestionDetailView: View {
    let questions: [Question]
    let currentIndex: Int
    @ObservedObject var viewModel: QuestionViewModel
    @State private var selectedLanguage: String = "en"
    @State private var isSaved: Bool = false
    @State private var selectedAnswer: String? = nil // Track the selected answer
    @State private var isAnswerCorrect: Bool? = nil // Track if the answer is correct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(translatedQuestion.question)
                .font(.title)
            
            VStack(alignment: .leading, spacing: 10) {
                OptionView(
                    text: translatedQuestion.a,
                    isSelected: selectedAnswer == "a",
                    isCorrect: isAnswerCorrect,
                    correctAnswer: questions[currentIndex].solution
                )
                .onTapGesture {
                    handleAnswerSelection(answer: "a")
                }
                
                OptionView(
                    text: translatedQuestion.b,
                    isSelected: selectedAnswer == "b",
                    isCorrect: isAnswerCorrect,
                    correctAnswer: questions[currentIndex].solution
                )
                .onTapGesture {
                    handleAnswerSelection(answer: "b")
                }
                
                OptionView(
                    text: translatedQuestion.c,
                    isSelected: selectedAnswer == "c",
                    isCorrect: isAnswerCorrect,
                    correctAnswer: questions[currentIndex].solution
                )
                .onTapGesture {
                    handleAnswerSelection(answer: "c")
                }
                
                OptionView(
                    text: translatedQuestion.d,
                    isSelected: selectedAnswer == "d",
                    isCorrect: isAnswerCorrect,
                    correctAnswer: questions[currentIndex].solution
                )
                .onTapGesture {
                    handleAnswerSelection(answer: "d")
                }
            }
            
            HStack {
                Button(action: {
                    viewModel.saveQuestion(questions[currentIndex])
                    isSaved = true
                }) {
                    Text(isSaved ? "Saved" : "Save")
                        .padding()
                        .background(isSaved ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button("Translate") {
                    selectedLanguage = selectedLanguage == "en" ? "de" : "en"
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            HStack {
                Button("Previous") {
                    if currentIndex > 0 {
                        let previousIndex = currentIndex - 1
                        navigateToQuestion(at: previousIndex)
                    }
                }
                .disabled(currentIndex == 0)
                
                Spacer()
                
                Button("Next") {
                    if currentIndex < questions.count - 1 {
                        let nextIndex = currentIndex + 1
                        navigateToQuestion(at: nextIndex)
                    }
                }
                .disabled(currentIndex == questions.count - 1)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Question \(questions[currentIndex].num)")
    }
    
    private var translatedQuestion: Question.Translation {
        questions[currentIndex].translation[selectedLanguage] ?? Question.Translation(
            question: questions[currentIndex].question,
            a: questions[currentIndex].a,
            b: questions[currentIndex].b,
            c: questions[currentIndex].c,
            d: questions[currentIndex].d,
            context: ""
        )
    }
    
    private func navigateToQuestion(at index: Int) {
        let question = questions[index]
        let detailView = QuestionDetailView(questions: questions, currentIndex: index, viewModel: viewModel)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: detailView)
        }
    }
    
    private func handleAnswerSelection(answer: String) {
        selectedAnswer = answer
        isAnswerCorrect = answer == questions[currentIndex].solution
    }
}

struct OptionView: View {
    let text: String
    let isSelected: Bool
    let isCorrect: Bool?
    let correctAnswer: String
    
    var body: some View {
        HStack {
            Image(systemName: getChecboxIcon())
                .foregroundColor(getCheckboxColor())
            Text(text)
                .foregroundColor(getTextColor())
        }
        .padding()
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
        return Color.clear
    }
}

#Preview {
    QuestionDetailView(questions: [Question.random()], currentIndex: 0,
                       viewModel: QuestionViewModel())
}
