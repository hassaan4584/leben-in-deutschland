//
//  QuestionListView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import SwiftUI

struct QuestionListView: View {
    @StateObject private var viewModel = QuestionViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                } else {
                    List(viewModel.questions.indices, id: \.self) { index in
                        NavigationLink(destination: QuestionDetailView(questions: viewModel.questions, currentIndex: index, viewModel: viewModel)) {
                            HStack(alignment: .top) {
                                Text("\(index + 1) ")
                                    .bold()
                                Text(viewModel.questions[index].question)
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("Questions")
            .onAppear {
                // Fetch questions only when the view appears
                if viewModel.questions.isEmpty {
                    viewModel.fetchQuestions()
                }
            }
        }
    }
}

#Preview {
    QuestionListView()
}
