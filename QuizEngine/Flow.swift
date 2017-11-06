import Foundation

protocol Router {
    
    func route(to question: String, answerCallback: @escaping (String) -> Void)

}

class Flow {
    let router: Router
    let questions: [String]
    
    init(questions: [String], router: Router) {
        self.questions = questions
        self.router = router
    }
    
    func start() {
        if let firstQuestion = questions.first {
            router.route(to: firstQuestion) { [weak self] _ in
                guard let strongSelf = self else { return }
                let firstQuestionIndex = strongSelf.questions.index(of: firstQuestion)!
                let nextQuestion = strongSelf.questions[firstQuestionIndex + 1]
                strongSelf.router.route(to: nextQuestion) { _ in }
                
            }
        }
    }
    
}
