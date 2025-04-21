//
//  QuestionViewModel.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//


import Foundation
import Combine
import NetworkLibrary
class QuestionViewModel: ObservableObject {
    @Published var questions: [Question]
    @Published var isLoading: Bool
    @Published var errorMessage: String?
//    @Published var savedQuestions: [Question]
    private let networkManager: NetworkManagerProtocol
    private let keyValueStorage: KeyValueStoring
    private var cancellables = Set<AnyCancellable>()
    let savedQuestionsKey = "saved_questions_ids_key"
    
    init(keyValueStorage: KeyValueStoring = UserDefaults.standard,
         cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
             questions = []
        self.isLoading = false
//        self.savedQuestions = savedQuestions
        self.keyValueStorage = keyValueStorage
        self.cancellables = cancellables
        self.networkManager = NetworkManager()
    }
    
    func fetchQuestions() {
        isLoading = true
        getQuestionsFromDisk()
//        NetworkManager.shared.fetchQuestions()
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                switch completion {
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                case .finished:
//                    break
//                }
//            } receiveValue: { [weak self] questions in
//                self?.questions = questions
//            }
//            .store(in: &cancellables)
    }
    
    func getQuestionsFromDisk() {
        let nsdata = NSData(contentsOfFile: Bundle.main.path(forResource: "question", ofType: "json")!)
        let data = Data(nsdata!)
        let questionList = try? JSONDecoder().decode([Question].self, from: data)
        self.isLoading = false
        guard let questionList else {
            self.errorMessage = "Failed to load questions"
            return
        }
        self.questions = Array(questionList[0...299])
    }
}

