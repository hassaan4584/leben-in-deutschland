//
//  QuestionListView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import SwiftUI

struct QuestionsListView: View {
    @StateObject var viewModel = QuestionsListViewModel()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                } else {
                    
                    List(viewModel.questions.indices, id: \.self) { index in
                        Button {
                            navigationPath.append(index)
                        } label: {
                            HStack(alignment: .top) {
                                Text("\(index + 1) ")
                                    .bold()
                                    .foregroundStyle(Color.primary)
                                Text(viewModel.getTranslatedQuestion(index))
                                    .foregroundStyle(Color.primary)

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
        .overlay(loadingOverlay)
        .navigationTitle("Questions")
        .onAppear {
            viewModel.viewWillAppear()
            // Fetch questions only when the view appears
            if viewModel.questions.isEmpty {
                viewModel.fetchQuestions()
            }
        }

    }
    
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    .scaleEffect(2.5)
                
            }
        }
    }
}
#Preview {
    QuestionsListView()
}
