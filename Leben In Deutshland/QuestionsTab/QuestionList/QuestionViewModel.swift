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
    @Published var selectedQuestionIndex: Int?
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    private let networkManager: NetworkManagerProtocol
    private let keyValueStorage: KeyValueStoring
    private let settingsService: SettingsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    let savedQuestionsKey = "saved_questions_ids_key"
    @Published private var appSettings = AppSettings.default
    
    init(keyValueStorage: KeyValueStoring = UserDefaults.standard,
         settingsService: SettingsServiceProtocol = SettingsService(),
         cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
             questions = []
        self.isLoading = false
        self.keyValueStorage = keyValueStorage
        self.settingsService = settingsService
        self.cancellables = cancellables
        self.networkManager = NetworkManager()
        
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

