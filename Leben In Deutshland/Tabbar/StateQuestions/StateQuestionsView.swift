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
            VStack(alignment: .trailing, spacing: 0) {
                Form {
                    Picker("Selected State", selection: $viewModel.selectedState) {
                        ForEach(viewModel.stateNames, id: \.self) { stateName in
                            Text(stateName)
                        }
                    }
                    .padding([.bottom], 0)
                }
                .frame(maxHeight: 100)
                .scrollDisabled(true)
                
                if viewModel.isLoading {
                    Spacer()
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
            .overlay(loadingOverlay)
            .onAppear {
                // Fetch questions only when the view appears
                if viewModel.selectedStateQuestions.isEmpty {
                    viewModel.getQuestionsFromDisk()
                }
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
    StateQuestionsView(viewModel: .init())
}
