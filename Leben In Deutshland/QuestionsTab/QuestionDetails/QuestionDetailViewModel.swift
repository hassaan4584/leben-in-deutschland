//
//  QuestionDetailViewModel.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 26.03.25.
//

import Foundation
import Combine

class QuestionDetailViewModel: ObservableObject {
    @Published var currentIndex: Int
    @Published var isSaved: Bool = false
    @Published var selectedLanguage: String
    @Published var selectedAnswer: String? = nil
    @Published var isAnswerCorrect: Bool? = nil
    
    /// The dictionary of [Index: IsQuestionAt'Index' correctly answered
    private var questionAttempts: [Int: Bool] = [:]
    let allQuestions: [Question]
    private let keyValueStorage: KeyValueStoring
    private let settingsService: SettingsServiceProtocol
    let savedQuestionsKey = "saved_questions_ids_key"
    private var cancellables = Set<AnyCancellable>()

    init(allQuestions: [Question],
         currentIndex: Int,
         settingsService: SettingsServiceProtocol = SettingsService(),
         keyValueStorage: KeyValueStoring = UserDefaults.standard) {
        self.allQuestions = allQuestions
        self.currentIndex = currentIndex
        self.settingsService = settingsService
        self.keyValueStorage = keyValueStorage
        self.selectedLanguage = AppSettings.default.primaryLanguage.code
        settingsService.loadSettings()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [unowned self] loadedSettings in
                self.selectedLanguage = loadedSettings.primaryLanguage.code
            }
            .store(in: &cancellables)

        
    }
    deinit {
            print("QuestionDetailViewModel deinitialized")
        }
    
    var translatedQuestion: Question.Translation {
        allQuestions[currentIndex].translation[selectedLanguage] ?? Question.Translation(
            question: allQuestions[currentIndex].question,
            a: allQuestions[currentIndex].a,
            b: allQuestions[currentIndex].b,
            c: allQuestions[currentIndex].c,
            d: allQuestions[currentIndex].d,
            context: ""
        )
    }
    
    var correctAnswer: String {
        allQuestions[currentIndex].solution
    }

    func loadQuestion(at index: Int) {
        currentIndex = index
        isSaved = isQuestionSaved(allQuestions[currentIndex])
        selectedAnswer = nil
        isAnswerCorrect = nil
        
    }
    
    func handleAnswerSelection(answer: String) {
        selectedAnswer = answer
        let isCorrect = answer == allQuestions[currentIndex].solution
        self.isAnswerCorrect = isCorrect
        questionAttempts[currentIndex] = isCorrect
    }
    
    func isQuestionCorrectlyAnswered(at index: Int) -> Bool? {
        return questionAttempts[index]
    }
    
    func translateQuestion() {
        settingsService.loadSettings()
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] loadedSettings in
                guard let self else { return }
                
                if selectedLanguage == loadedSettings.primaryLanguage.code {
                    selectedLanguage = loadedSettings.secondaryLanguage.code
                } else {
                    selectedLanguage = loadedSettings.primaryLanguage.code
                }
            }
            .store(in: &cancellables)
    }
    
    func saveQuestion(_ question: Question) {
        guard var savedQuestionIds: [String] = keyValueStorage.value(for: savedQuestionsKey)
        else {
            keyValueStorage.setValue([question.id], for: savedQuestionsKey)
            return
        }
        
        if !savedQuestionIds.contains(where: { $0 == question.id }) {
            savedQuestionIds.append(question.id)
        } else {
            savedQuestionIds.removeAll(where: { $0 == question.id })
        }
        keyValueStorage.setValue(savedQuestionIds, for: savedQuestionsKey)
    }
    
    func isQuestionSaved(_ question: Question) -> Bool {
        guard let savedQuestionIds: [String] = keyValueStorage.value(for: savedQuestionsKey)
        else {
            return false
        }
        return savedQuestionIds.contains(where: { $0 == question.id })
    }
}
