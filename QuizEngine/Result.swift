import Foundation

struct Result<Question: Hashable, Answer> {
  let answers: [Question: Answer]
  let score: Int
}
