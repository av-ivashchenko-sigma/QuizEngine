import Foundation

public func startGame<Question, Answer: Equatable, R: Router>(questions: [Question], router: R, correctAnswers: [Question: Answer]) where R.Question == Question, R.Answer == Answer {
  
}