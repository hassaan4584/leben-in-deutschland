import Foundation
import Combine

class StateQuestionsViewModel: ObservableObject {
    
    @Published var stateNames: [String]
    @Published var selectedStateQuestions: [Question] = []
    @Published var questionIds: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedState: String = "Berlin" {
        didSet {
            self.selectedStateQuestions = self.filterQuestionsByState()
        }
    }
    private var stateQuestions: [Question] = []
    private let germanStates: [String: String] = [
        "Brandenburg": "BB",
        "Berlin": "BE",
        "Baden-Württemberg": "BW",
        "Bavaria": "BY",
        "Bremen": "HB",
        "Hesse": "HE",
        "Hamburg": "HH",
        "Lower Saxony": "NI",
        "North Rhine-Westphalia": "NW",
        "Mecklenburg-Vorpommern": "MV",
        "Rhineland-Palatinate": "RP",
        "Schleswig-Holstein": "SH",
        "Saarland": "SL",
        "Saxony": "SN",
        "Saxony-Anhalt": "ST",
        "Thuringia": "TH"
    ]
    private let settingsService: SettingsServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        settingsService: SettingsServiceProtocol = SettingsService()
    ) {
        self.stateNames = germanStates.keys.sorted()
        self.selectedState = AppSettings.default.defaultState
        self.settingsService = settingsService
        settingsService.loadSettings()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [unowned self] loadedSettings in
                self.selectedState = loadedSettings.defaultState
            }
            .store(in: &cancellables)
    }
    
    func filterQuestionsByState() -> [Question] {
        guard let selectedStateKey = germanStates[selectedState] else { return [] }
        let stateSpecificQuestions = stateQuestions.filter { $0.num.starts(with: selectedStateKey ) }
        return stateSpecificQuestions
    }

    func getQuestionsFromDisk() {
        isLoading = true
        self.getQuestionsFromDiskWithPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] questionList in
                guard let self = self else { return }
                self.selectedStateQuestions = questionList
                self.isLoading = false
            }
            .store(in: &cancellables)
    }

    func getQuestionsFromDiskWithPublisher() -> AnyPublisher<[Question], Error> {
        Future<[Question], Error> { [weak self] promise in
            Task {
                
                guard let self = self else { return }
                
                do {
                    let nsdata = NSData(contentsOfFile: Bundle.main.path(forResource: "question", ofType: "json")!)
                    let data = Data(nsdata!)
                    let questionList = try JSONDecoder().decode([Question].self, from: data)
                    guard questionList.count > 300 else {
                        self.errorMessage = "No State Questions found"
                        return
                    }
                    self.stateQuestions = Array(questionList[300...])
                    let selectedStateQuestions = self.filterQuestionsByState()
                    
                    promise(.success(selectedStateQuestions))
                } catch {
                    //                self.errorMessage = "Could not load questions"
                    //                self.isLoading = false
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
