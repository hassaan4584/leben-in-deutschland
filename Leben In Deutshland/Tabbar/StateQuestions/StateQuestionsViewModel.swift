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
            guard let selectedStateKey = germanStates[selectedState] else { return }
            self.selectedStateQuestions = self.filterQuestions(state: selectedStateKey,
                                                               questions: self.allStateQuestions)
        }
    }
    private var allStateQuestions: [Question] = []
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
    private let questionService: QuestionServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        settingsService: SettingsServiceProtocol = SettingsService(),
        questionService: QuestionServiceProtocol = QuestionsService()
    ) {
        self.stateNames = germanStates.keys.sorted()
        self.selectedState = AppSettings.default.defaultState
        self.questionService = questionService
        self.settingsService = settingsService
        settingsService.loadSettings()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [unowned self] loadedSettings in
                self.selectedState = loadedSettings.defaultState
            }
            .store(in: &cancellables)
    }
    
    func filterQuestions(state: String, questions: [Question]) -> [Question] {
        let stateSpecificQuestions = questions.filter { $0.num.starts(with: state ) }
        return stateSpecificQuestions
    }

    func getQuestionsFromDisk() {
        isLoading = true
        self.questionService.getQuestionsFromDiskWithPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] questionList in
                guard let self = self else { return }
                self.allStateQuestions = questionList
                guard let selectedStateKey = germanStates[selectedState] else { return }
                self.selectedStateQuestions = self.filterQuestions(state: selectedStateKey,
                                                                          questions: questionList)
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
