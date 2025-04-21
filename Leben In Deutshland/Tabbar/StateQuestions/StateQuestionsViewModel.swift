import Foundation

class StateQuestionsViewModel: ObservableObject {
    
    
    @Published var stateNames: [String]
    @Published var selectedStateQuestions: [Question] = []
    @Published var selectedState: String = "Berlin" {
        didSet {
            self.selectedStateQuestions = self.filterQuestionsByState()
        }
    }
    @Published private var stateQuestions: [Question] = []
    @Published var questionIds: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
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
    
    init() {
        self.stateNames = germanStates.keys.sorted()
        self.selectedState = "Berlin"
    }

    func filterQuestionsByState() -> [Question] {
        guard let selectedStateKey = germanStates[selectedState] else { return [] }
//        let questionIds = stateQuestions.map(\.num)
//        let stateSpecificQuestionsIds = questionIds.filter { $0.contains(selectedStateKey)}
        let stateSpecificQuestions = stateQuestions.filter { $0.num.starts(with: selectedStateKey ) }
        return stateSpecificQuestions
    }

    
    func getQuestionsFromDisk() {
        let nsdata = NSData(contentsOfFile: Bundle.main.path(forResource: "question", ofType: "json")!)
        let data = Data(nsdata!)
        let questionList = try? JSONDecoder().decode([Question].self, from: data)
        guard let questionList else {
            errorMessage = "Could not load questions"
            return
        }
        guard questionList.count > 300 else {
            errorMessage = "No State Questions found"
            return
        }
        self.stateQuestions = Array(questionList[300...])
        self.selectedStateQuestions = self.filterQuestionsByState()

        
    }

    
}
