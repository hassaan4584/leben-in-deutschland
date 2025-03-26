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
    @State private var currentIndex: Int
    var viewModel: QuestionDetailViewModel
//    @State private var selectedQuestion: Question
    @State private var selectedLanguage: String = "en"
    @State private var isSaved: Bool = false
    @State private var selectedAnswer: String? = nil // Track the selected answer
    @State private var isAnswerCorrect: Bool? = nil // Track if the answer is correct
    
    init(questions: [Question],
         currentIndex: Int,
         viewModel: QuestionDetailViewModel,
         selectedQuestion: Question,
         selectedLanguage: String = "de",
         selectedAnswer: String? = nil,
         isAnswerCorrect: Bool? = nil) {
        self.questions = questions
        self.currentIndex = currentIndex
        self.viewModel = viewModel
//        self.selectedQuestion = selectedQuestion
        self.selectedLanguage = selectedLanguage
//        self.isSaved = isSaved
        self.selectedAnswer = selectedAnswer
        self.isAnswerCorrect = isAnswerCorrect
    }
    
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
                    isSaved = viewModel.isQuestionSaved(questions[currentIndex])
                }) {
                    Text(
                        isSaved ? "Saved" : "Save")
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
//                        navigateToQuestion(at: previousIndex)
                        loadQuestion(at: previousIndex)
                    }
                }
                .disabled(currentIndex == 0)
                
                Spacer()
                
                Button("Next") {
                    if currentIndex < questions.count - 1 {
                        let nextIndex = currentIndex + 1
//                        navigateToQuestion(at: nextIndex)
                        loadQuestion(at: nextIndex)
                        
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
//        selectedQuestion.translation[selectedLanguage] ?? Question.Translation(
//            question: selectedQuestion.question,
//            a: questions[currentIndex].a,
//            b: questions[currentIndex].b,
//            c: questions[currentIndex].c,
//            d: questions[currentIndex].d,
//            context: ""
//        )
        questions[currentIndex].translation[selectedLanguage] ?? Question.Translation(
            question: questions[currentIndex].question,
            a: questions[currentIndex].a,
            b: questions[currentIndex].b,
            c: questions[currentIndex].c,
            d: questions[currentIndex].d,
            context: ""
        )
    }
    
    private func loadQuestion(at index: Int) {
        currentIndex = index
//        selectedQuestion = questions[index]
        isSaved = viewModel.isQuestionSaved(questions[currentIndex])
        selectedAnswer = nil
        isAnswerCorrect = nil
        
    }
    
    private func handleAnswerSelection(answer: String) {
        selectedAnswer = answer
        isAnswerCorrect = answer == questions[currentIndex].solution
    }
}


#Preview {
    let question1 = Question.random()
    let question2 = Question.random()
    let questions = [question1, question2]
    
    QuestionDetailView(questions: questions,
                       currentIndex: 0,
                       viewModel: QuestionDetailViewModel(allQuestions: questions),
                       selectedQuestion: question1)
}
