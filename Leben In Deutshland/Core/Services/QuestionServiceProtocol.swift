//
//  QuestionServiceProtocol.swift
//  Leben In Deutschland
//
//  Created by Hassaan Ahmed on 09.05.25.
//

import Combine
import Foundation

protocol QuestionServiceProtocol {
    func getQuestionsFromDiskWithPublisher() -> AnyPublisher<[Question], Error>
    func getQuestionsFromDisk() async throws -> [Question]
    
    func getQuestionsAsync() async throws -> [Question]
}

class QuestionsService: QuestionServiceProtocol {
    func getQuestionsFromDiskWithPublisher() -> AnyPublisher<[Question], Error> {
        Future<[Question], Error> { promise in
            Task {
                do {
                    let nsdata = NSData(contentsOfFile: Bundle.main.path(forResource: "question", ofType: "json")!)
                    let data = Data(nsdata!)
                    let questionList = try JSONDecoder().decode([Question].self, from: data)
                    guard questionList.count > 300 else {
                        promise(.failure(StateSelectionError.noQuestionsAvailable))
                        return
                    }
                    promise(.success(questionList))
                } catch {
                    promise(.failure(StateSelectionError.unableToReadQuestionsFile))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getQuestionsFromDisk() async throws -> [Question] {
        guard let path = Bundle.main.path(forResource: "question", ofType: "json"),
              let nsdata = NSData(contentsOfFile: path) else {
            throw StateSelectionError.unableToReadQuestionsFile
        }

        let data = Data(nsdata)

        let questionList = try JSONDecoder().decode([Question].self, from: data)

        guard questionList.count > 300 else {
            throw StateSelectionError.noQuestionsAvailable
        }

        return Array(questionList[300...])
    }
    
    func getQuestionsAsync() async throws -> [Question] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    guard let path = Bundle.main.path(forResource: "question", ofType: "json"),
                          let nsdata = NSData(contentsOfFile: path) else {
                        throw StateSelectionError.unableToReadQuestionsFile
                    }
//                    let data = try Data(contentsOf: url)
                    let data = Data(nsdata)
                    let questionList = try JSONDecoder().decode([Question].self, from: data)

                    guard questionList.count > 300 else {
                        throw StateSelectionError.noQuestionsAvailable
                    }

//                    return Array(questionList[300...])
                    continuation.resume(returning: Array(questionList[300...]))

                    
//                    let decoded = try JSONDecoder().decode(T.self, from: data)
//                    continuation.resume(returning: decoded)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

}

