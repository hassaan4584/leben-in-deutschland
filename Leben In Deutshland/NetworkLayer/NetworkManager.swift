//
//  NetworkManager.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 16.03.25.
//

import Foundation

//class NetworkManager: ObservableObject {
//    @Published var quizItems: [QuizItem] = []
//    @Published var loading: Bool = false // New property to track loading state
//    
//    func fetchQuestions() {
//        guard let url = URL(string: "https://hassaan4584.github.io/hassaan.github.io/questions/allQuestions.json") else { return }
//        
//        self.loading = true // Set loading to true when starting to fetch data
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error fetching data: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.loading = false // Set loading to false when an error occurs
//                }
//                return
//            }
//            
//            guard let data = data else {
//                print("No data received")
//                DispatchQueue.main.async {
//                    self.loading = false // Set loading to false if no data is received
//                }
//                return
//            }
//            
//            // Decode the JSON data into QuizItem objects
//            do {
//                let decoder = JSONDecoder()
//                let decodedItems = try decoder.decode([QuizItem].self, from: data)
//                DispatchQueue.main.async {
//                    self.quizItems = decodedItems
//                    self.loading = false // Set loading to false when data is successfully fetched
//                }
//            } catch {
//                print("Error decoding data: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self.loading = false // Set loading to false in case of a decoding error
//                }
//            }
//        }
//        
//        task.resume()
//    }
//}

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private let urlString = "https://hassaan4584.github.io/hassaan.github.io/questions/allQuestions.json"
    
    func fetchQuestions() -> AnyPublisher<[Question], Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Question].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
