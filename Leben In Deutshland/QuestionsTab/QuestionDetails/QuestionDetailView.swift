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
    @State private var currentIndex: Int
    var viewModel: QuestionDetailViewModel
    @State private var selectedLanguage: String = "en"
    @State private var isSaved: Bool = false
    @State private var selectedAnswer: String? = nil // Track the selected answer
    @State private var isAnswerCorrect: Bool? = nil // Track if the answer is correct
    
    init(currentIndex: Int,
         viewModel: QuestionDetailViewModel,
         selectedQuestion: Question,
         selectedLanguage: String = "de",
         selectedAnswer: String? = nil,
         isAnswerCorrect: Bool? = nil) {
        self.currentIndex = currentIndex
        self.viewModel = viewModel
        self.selectedLanguage = selectedLanguage
        self.selectedAnswer = selectedAnswer
        self.isAnswerCorrect = isAnswerCorrect
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text(translatedQuestion.question)
                        .font(.title2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        OptionView(
                            text: translatedQuestion.a,
                            isSelected: selectedAnswer == "a",
                            isCorrect: isAnswerCorrect,
                            correctAnswer: viewModel.allQuestions[currentIndex].solution
                        )
                        .onTapGesture {
                            handleAnswerSelection(answer: "a")
                        }
                        
                        OptionView(
                            text: translatedQuestion.b,
                            isSelected: selectedAnswer == "b",
                            isCorrect: isAnswerCorrect,
                            correctAnswer: viewModel.allQuestions[currentIndex].solution
                        )
                        .onTapGesture {
                            handleAnswerSelection(answer: "b")
                        }
                        
                        OptionView(
                            text: translatedQuestion.c,
                            isSelected: selectedAnswer == "c",
                            isCorrect: isAnswerCorrect,
                            correctAnswer: viewModel.allQuestions[currentIndex].solution
                        )
                        .onTapGesture {
                            handleAnswerSelection(answer: "c")
                        }
                        
                        OptionView(
                            text: translatedQuestion.d,
                            isSelected: selectedAnswer == "d",
                            isCorrect: isAnswerCorrect,
                            correctAnswer: viewModel.allQuestions[currentIndex].solution
                        )
                        .onTapGesture {
                            handleAnswerSelection(answer: "d")
                        }
                    }
                    
                    Spacer()
                    
                }
//                .navigationTitle("Question \(questions[currentIndex].num)")
            }
            HStack {
                Button(action: {
                    viewModel.saveQuestion(viewModel.allQuestions[currentIndex])
                    isSaved = viewModel.isQuestionSaved(viewModel.allQuestions[currentIndex])
                }) {
                    Text(
                        isSaved ? "Saved" : "Save")
                    .padding(EdgeInsets.init(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .background(isSaved ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Spacer()
                
                Button("Translate") {
                    selectedLanguage = selectedLanguage == "en" ? "de" : "en"
                }
                .padding(EdgeInsets.init(top: 12, leading: 16, bottom: 12, trailing: 16))
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
//            .padding([.top, .trailing], 0)
//            .background(Color.red.opacity(0.2))
            
            
            HStack {
                Button("Previous") {
                    if currentIndex > 0 {
                        let previousIndex = currentIndex - 1
                        loadQuestion(at: previousIndex)
                    }
                }
                .disabled(currentIndex == 0)
                
                Spacer()
                
                Button("Next") {
                    if currentIndex < viewModel.allQuestions.count - 1 {
                        let nextIndex = currentIndex + 1
                        loadQuestion(at: nextIndex)
                    }
                }
                .disabled(currentIndex == viewModel.allQuestions.count - 1)
            }
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(viewModel.allQuestions.indices, id: \.self) { index in
                            
                            VStack {
                                ZStack {
                                    Button("\(index + 1)") {
                                        let nextIndex = index
                                        loadQuestion(at: nextIndex)
                                        // Scroll to the selected index with animation
                                        withAnimation {
                                            proxy.scrollTo(index, anchor: .center)
                                        }                                }
                                    .bold()
                                    .frame(width: 40, height: 40)
                                    .background(RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.blue))
                                    .foregroundColor(.white)
                                    if viewModel.isQuestionSaved(viewModel.allQuestions[index]) {
                                        Image(systemName: "bookmark.fill")
                                            .offset(x: -15, y: -10)
                                            .foregroundStyle(Color.red.opacity(0.9))
                                    }
//                                    if isAnswerCorrect == true {
//                                        Image(systemName: "checkmark.circle.fill")
//                                            .offset(x: 15, y: 10)
//                                            .foregroundStyle(Color.green.opacity(0.9))
//                                    } else if isAnswerCorrect == false {
//                                        Image(systemName: "checkmark.circle.fill")
//                                            .offset(x: 15, y: 10)
//                                            .foregroundStyle(Color.red.opacity(0.9))
//                                    }
                                }
//                                .disabled(currentIndex == questions.count - 1)
                                
                            }
                            .padding()
                            .id(index) // Important: Assign ID for scrolling
                            .frame(width: 50, height: 50)
                            .background(getBackgroundColorForQuestions(index: index))
                            .cornerRadius(10)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10) .fill(Color.gray.opacity(0.2)))
                    
                }
                .onChange(of: currentIndex, { _, newIndex in
                    withAnimation {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                })
            }
        }
        .padding()
        .navigationTitle("Question \(viewModel.allQuestions[currentIndex].num)")
    }

    
    private var translatedQuestion: Question.Translation {
        viewModel.allQuestions[currentIndex].translation[selectedLanguage] ?? Question.Translation(
            question: viewModel.allQuestions[currentIndex].question,
            a: viewModel.allQuestions[currentIndex].a,
            b: viewModel.allQuestions[currentIndex].b,
            c: viewModel.allQuestions[currentIndex].c,
            d: viewModel.allQuestions[currentIndex].d,
            context: ""
        )
    }
    
    private func loadQuestion(at index: Int) {
        currentIndex = index
        isSaved = viewModel.isQuestionSaved(viewModel.allQuestions[currentIndex])
        selectedAnswer = nil
        isAnswerCorrect = nil
        
    }
    
    private func handleAnswerSelection(answer: String) {
        selectedAnswer = answer
        isAnswerCorrect = answer == viewModel.allQuestions[currentIndex].solution
    }
    
    private func getBackgroundColorForQuestions(index: Int) -> Color {
        if index == currentIndex {
            return Color(.systemGray2)
        }
        return Color(.systemGray6)
    }
}


#Preview {
    let question1 = Question.random()
    let question2 = Question.random()
    let questions = [question1, question2, .random(), .random(), .random(), .random(), .random(), .random(), .random(), .random(), .random()]
    
    QuestionDetailView(currentIndex: 0,
                       viewModel: QuestionDetailViewModel(allQuestions: questions),
                       selectedQuestion: question1)
}
