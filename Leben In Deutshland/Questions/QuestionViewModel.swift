//
//  QuestionViewModel.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//


import Foundation
import Combine

class QuestionViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var savedQuestions: [Question] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchQuestions() {
        isLoading = true
        NetworkManager.shared.fetchQuestions()
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] questions in
                self?.questions = questions
            }
            .store(in: &cancellables)
    }
    
    func saveQuestion(_ question: Question) {
        if !savedQuestions.contains(where: { $0.id == question.id }) {
            savedQuestions.append(question)
        }
    }
}
