//
//  QuestionsListViewModel.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//


import Foundation
import Combine

class QuestionsListViewModel: ObservableObject {
    @Published var questions: [Question]
    @Published var selectedQuestionIndex: Int?
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    private let keyValueStorage: KeyValueStoring
    private let settingsService: SettingsServiceProtocol
    private let questionsService: QuestionServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    let savedQuestionsKey = "saved_questions_ids_key"
    @Published private var appSettings = AppSettings.default
    
    init(keyValueStorage: KeyValueStoring = UserDefaults.standard,
         settingsService: SettingsServiceProtocol = SettingsService(),
         questionsService: QuestionServiceProtocol = QuestionsService(),
         cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        questions = []
        self.isLoading = false
        self.keyValueStorage = keyValueStorage
        self.settingsService = settingsService
        self.questionsService = questionsService
        self.cancellables = cancellables
        
        settingsService.loadSettings()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [unowned self] loadedSettings in
                self.appSettings = loadedSettings
            }
            .store(in: &self.cancellables)
    }
    
    func getTranslatedQuestion(_ index: Int) -> String {
        (questions[index].translation[appSettings.primaryLanguage.code]?.question ?? questions[index].question)
    }
    
    func viewWillAppear() {
        settingsService.loadSettings()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] newSettings in
                guard let self else { return }
                if newSettings.primaryLanguage.code != self.appSettings.primaryLanguage.code {
                    self.appSettings = newSettings
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchQuestions() {
//        isLoading = true
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
        self.isLoading = true
        self.questionsService.getQuestionsFromDiskWithPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let err = error as? StateSelectionError {
                        self?.errorMessage = err.localizedDescription
                    } else {
                        self?.errorMessage = StateSelectionError.unknown.localizedDescription
                    }
                    self?.isLoading = false
                }
            } receiveValue: { questionList in
                self.questions = questionList
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
