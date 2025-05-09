//
//  QuestionDetailView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import SwiftUI

struct QuestionDetailView: View {
    var currentIndex: Int {
        viewModel.currentIndex
    }
    var translatedQuestion: Question.Translation {
        viewModel.translatedQuestion
    }
    
    var correctAnswer: String {
        viewModel.correctAnswer
    }
    var selectedAnswer: String? {
        viewModel.selectedAnswer
    }
    
    var isSaved: Bool {
        viewModel.isSaved
    }
    
    var isAnswerCorrect: Bool? {
        viewModel.isAnswerCorrect
    }
    
    @ObservedObject var viewModel: QuestionDetailViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: QuestionDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text(translatedQuestion.question)
                        .font(.title2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        let optionViewModelA = OptionViewModel(translatedQuestion: translatedQuestion.a,
                                                              isSelected: selectedAnswer == "a",
                                                              isCorrect: isAnswerCorrect,
                                                               correctAnswer: correctAnswer)
                        OptionView(viewModel: optionViewModelA)
                        .onTapGesture {
                            viewModel.handleAnswerSelection(answer: "a")
                        }
                        
                        let optionViewModelB = OptionViewModel(translatedQuestion: translatedQuestion.b,
                                                              isSelected: selectedAnswer == "b",
                                                              isCorrect: isAnswerCorrect,
                                                              correctAnswer: correctAnswer)
                        OptionView(viewModel: optionViewModelB)
                        .onTapGesture {
                            viewModel.handleAnswerSelection(answer: "b")
                        }
                        
                        let optionViewModelC = OptionViewModel(translatedQuestion: translatedQuestion.c,
                                                              isSelected: selectedAnswer == "c",
                                                              isCorrect: isAnswerCorrect,
                                                              correctAnswer: correctAnswer)
                        OptionView(viewModel: optionViewModelC)
                        .onTapGesture {
                            viewModel.handleAnswerSelection(answer: "c")
                        }
                        
                        let optionViewModelD = OptionViewModel(translatedQuestion: translatedQuestion.d,
                                                              isSelected: selectedAnswer == "d",
                                                              isCorrect: isAnswerCorrect,
                                                              correctAnswer: correctAnswer)
                        OptionView(viewModel: optionViewModelD)
                        .onTapGesture {
                            viewModel.handleAnswerSelection(answer: "d")
                        }
                    }
                    Spacer()
                }
            }
            HStack {
                Button(action: {
                    viewModel.saveQuestion(viewModel.allQuestions[viewModel.currentIndex])
                    viewModel.isSaved = viewModel.isQuestionSaved(viewModel.allQuestions[viewModel.currentIndex])
                }) {
                    Text(isSaved ? "Unmark" : "Mark")
                }
                .buttonStyle(HighlightButtonStyle())
                
                Spacer()
                
                Button(action: { viewModel.translateQuestion() }) {
                    Text("Translate")
                }
                .buttonStyle(HighlightButtonStyle())
            }

            HStack {
                Button("Previous") {
                    if currentIndex > 0 {
                        let previousIndex = viewModel.currentIndex - 1
                        viewModel.loadQuestion(at: previousIndex)
                    }
                }
                .disabled(currentIndex == 0)
                
                Spacer()
                
                Button("Next") {
                    if viewModel.currentIndex < viewModel.allQuestions.count - 1 {
                        let nextIndex = viewModel.currentIndex + 1
                        viewModel.loadQuestion(at: nextIndex)
                    }
                }
                .disabled(viewModel.currentIndex == viewModel.allQuestions.count - 1)
            }
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(viewModel.allQuestions.indices, id: \.self) { index in
                            VStack {
                                ZStack {
                                    Button(action: {
                                        let nextIndex = index
                                        viewModel.loadQuestion(at: nextIndex)
                                        // Scroll to the selected index with animation
                                        withAnimation {
                                            proxy.scrollTo(index, anchor: .center)
                                        }
                                    }) {
                                        Text("\(index + 1)")
                                    }
                                    .bold()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .background( RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.blue)
                                        .shadow(color: getShadowColorForQuestions(index: index), radius: 2, x:2, y:4))
                                    if viewModel.isQuestionSaved(viewModel.allQuestions[index]) {
                                        Image(systemName: "bookmark.fill")
                                            .offset(x: -19, y: -16)
                                            .foregroundStyle(Color.black.opacity(0.9))
                                        
                                    }
                                    let isCorrectlyAnswered = viewModel.isQuestionCorrectlyAnswered(at: index)
                                    if isCorrectlyAnswered == true {
                                        Image(systemName: "checkmark.square.fill")
                                            .foregroundStyle(Color.green)
                                            .background( Circle()
                                                .fill(Color.black)
                                                .frame(width: 10, height: 10)
                                            )
                                            .offset(x: 17, y: 17)

                                    } else if isCorrectlyAnswered == false {
                                        Image(systemName: "xmark.square.fill")
                                            .foregroundStyle(Color.red.opacity(0.9))
                                            .background( Circle()
                                                .fill(Color.black)
                                                .frame(width: 10, height: 10)
                                            )
                                            .offset(x: 17, y: 17)
                                    }
                                }
                            }
                            .padding()
                            .id(index) // Assigning id for scrolling
                            .frame(width: 60, height: 60)
                            .cornerRadius(10)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                    )
                }
                .onChange(of: viewModel.currentIndex, { _, newIndex in
                    withAnimation {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                })
                .onAppear() {
                    proxy.scrollTo(viewModel.currentIndex, anchor: .center)
                }
                .background(RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray5))
                    .shadow(color: Color.primary.opacity(0.1), radius: 5, x:2, y:5)
                )

            }
        }
        .padding()
        .navigationTitle("Question \(viewModel.allQuestions[viewModel.currentIndex].num)")
        .onAppear {
            // Fetch questions only when the view appears
            viewModel.loadQuestion(at: currentIndex)
        }
    }

    private func getBackgroundColorForQuestions(index: Int) -> Color {
        if index == currentIndex {
            return Color(.systemGray2)
        }
        return Color(.clear)
    }
    
    private func getShadowColorForQuestions(index: Int) -> Color {
        if index == currentIndex {
            return Color.primary.opacity(0.2)
        }
        return Color(.clear)
    }
}


#Preview {
    let question1 = Question.random()
    let question2 = Question.random()
    let questions = [question1, question2, .random(), .random(), .random(), .random(), .random(), .random(), .random(), .random(), .random()]
    
    let vm = QuestionDetailViewModel(allQuestions: questions, currentIndex: 0)
    
    QuestionDetailView(viewModel: vm)
}
