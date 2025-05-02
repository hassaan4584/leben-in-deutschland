//
//  QuestionListView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import SwiftUI

struct QuestionsListView: View {
    @StateObject var viewModel = QuestionViewModel()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                } else {
                    
                    List(viewModel.questions.indices, id: \.self) { index in
                        Button {
                            navigationPath.append(index)
                        } label: {
                            HStack(alignment: .top) {
                                Text("\(index + 1) ")
                                    .bold()
                                    .foregroundStyle(.black)
                                Text(viewModel.getTranslatedQuestion(index))
                                    .foregroundStyle(.black)

                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Int.self) { index in
                QuestionDetailView(
                    viewModel: QuestionDetailViewModel(
                        allQuestions: viewModel.questions,
                        currentIndex: index
                    )
                )
            }
        }
        .navigationTitle("Questions")
        .onAppear {
            // Fetch questions only when the view appears
            if viewModel.questions.isEmpty {
                viewModel.fetchQuestions()
            } else {
                viewModel.viewWillAppear()
            }
        }

    }
}
#Preview {
    QuestionsListView()
}
