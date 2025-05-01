//
//  QuestionDetailViewModel.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 26.03.25.
//

import Foundation

protocol KeyValueStoring {
    func value<T>(for key: String) -> T?
    func setValue<T>(_ value: T, for key: String)
    func removeValue(for key: String)
}

extension UserDefaults: KeyValueStoring {
    public func value<T>(for key: String) -> T? {
      object(forKey: key) as? T
    }

    public func setValue<T>(_ value: T, for key: String) {
      set(value, forKey: key)
    }

    public func removeValue(for key: String) {
      removeObject(forKey: key)
    }
  }

struct QuestionDetailViewModel {
    let allQuestions: [Question]
    private let keyValueStorage: KeyValueStoring
    let savedQuestionsKey = "saved_questions_ids_key"
    
    init(allQuestions: [Question],
         keyValueStorage: KeyValueStoring = UserDefaults.standard) {
        self.allQuestions = allQuestions
        self.keyValueStorage = keyValueStorage
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
