//
//  StateQuestionsView.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 19.04.25.
//

import SwiftUI

struct StateQuestionsView: View {
    @StateObject var viewModel: StateQuestionsViewModel
    
    var body: some View {
        
        NavigationView {
            
            
            VStack {
                
                Text("Selected State: \(viewModel.selectedState)")
                    .font(.title2)
                    .padding()
                
                
                Picker("Select a State", selection: $viewModel.selectedState) {
                    ForEach(viewModel.stateNames, id: \.self) { stateName in
                        Text(stateName)
                    }
                }
                .pickerStyle(.menu)
                .padding()

                
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                }
                    else {
                        List(viewModel.selectedStateQuestions.indices, id: \.self) { index in
                            NavigationLink(destination: QuestionDetailView(viewModel: QuestionDetailViewModel(allQuestions: viewModel.selectedStateQuestions, currentIndex: index))) {
                            HStack(alignment: .top) {
                                Text("\(index + 1) ")
                                    .bold()
                                Text(viewModel.selectedStateQuestions[index].num)
                            }
                            
                        }
                    }
                }
            }
            .navigationTitle("State Questions")
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
