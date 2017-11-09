import Foundation

public struct Result<Question: Hashable, Answer> {
  public let answers: [Question: Answer]
  public let score: Int
}
