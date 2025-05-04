//
//  StateQuestionsView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 19.04.25.
//

import SwiftUI

struct StateQuestionsView: View {
    @StateObject var viewModel: StateQuestionsViewModel
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                Form {
                    Picker("Select a State", selection: $viewModel.selectedState) {
                        ForEach(viewModel.stateNames, id: \.self) { stateName in
                            Text(stateName)
                        }
                    }
                    .padding([.bottom], 0)
                }
                .frame(maxHeight: 100)
                .scrollDisabled(true)
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                }
                else {
                    List(viewModel.selectedStateQuestions.indices, id: \.self) { index in
                        Button {
                            navigationPath.append(index)
                        } label: {
                            HStack(alignment: .top) {
                                Text("\(index + 1) ")
                                    .bold()
                                    .foregroundStyle(.black)
                                Text(viewModel.selectedStateQuestions[index].num)
                                    .foregroundStyle(.black)
                                
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Int.self) { index in
                QuestionDetailView(viewModel: QuestionDetailViewModel(allQuestions:
                                                                        viewModel.selectedStateQuestions,
                                                                      currentIndex: index))
            }
            .navigationTitle("State Questions")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Fetch questions only when the view appears
                if viewModel.selectedStateQuestions.isEmpty {
                    viewModel.getQuestionsFromDisk()
                }
            }
        }
    }
}

#Preview {
    StateQuestionsView(viewModel: .init())
}
