//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Aleksandr Ivashchenko on 10/26/17.
//  Copyright © 2017 Sigma Software. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
  
  let router = RouterSpy()
  
  func testStartWithNoQuestions_doesntRouteToQuestion() {
    makeSUT(questions: []).start()
    
    XCTAssertTrue(router.routedQuestions.isEmpty)
  }
  
  func testStartWithOneQuestion_rotesToCorrectQuestion() {
    makeSUT(questions: ["Q1"]).start()
    
    XCTAssertEqual(router.routedQuestions, ["Q1"])
  }
  
  func testStartWithOneQuestion_rotesToCorrectQuestion_2() {
    makeSUT(questions: ["Q2"]).start()
    
    XCTAssertEqual(router.routedQuestions, ["Q2"])
  }
  
  func testStartWithTwoQuestions_rotesToFirstQuestion() {
    makeSUT(questions: ["Q1", "Q2"]).start()
    
    XCTAssertEqual(router.routedQuestions, ["Q1"])
  }
  
  func test_startTwice_withTwoQuestions_rotesToFirstQuestionTwice() {
    let sut = makeSUT(questions: ["Q1", "Q2"])
    
    sut.start()
    sut.start()
    
    XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
  }
  
  func test_startAndAnswerFirstQuestion_withTwoQuestions_rotesToSecondQuestion() {
    let sut = makeSUT(questions: ["Q1", "Q2"])
    sut.start()
    
    router.answerCallback("A1")
    
    XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
  }
  
  
  func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_rotesToSecondAndThirdQuestion() {
    let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
    sut.start()
    
    router.answerCallback("A1")
    router.answerCallback("A2")
    
    XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
  }
  
  func test_startAndAnswerFirstQuestion_withOneQuestion_doesntRouteToAnotherQuestion() {
    let sut = makeSUT(questions: ["Q1"])
    sut.start()
    
    router.answerCallback("A1")
    
    XCTAssertEqual(router.routedQuestions, ["Q1"])
  }
  
  func testStartWithNoQuestions_doesntRouteToResult() {
    makeSUT(questions: []).start()
    
    XCTAssertEqual(router.routedResult!, [:])
  }
  
  func testStartWithOneQuestion_doesntRouteToResult() {
    makeSUT(questions: ["Q1"]).start()
    
    XCTAssertNil(router.routedResult)
  }
  
  func test_startAndAnswerFirstQuestion_withOneQuestion_routesToResult() {
    let sut = makeSUT(questions: ["Q1"])
    sut.start()
    
    router.answerCallback("A1")
    
    XCTAssertEqual(router.routedResult!, ["Q1": "A1"])

  }
  
  func test_startAndAnswerFirstQuestion_withTwoQuestions_doesntRouteToResult() {
    let sut = makeSUT(questions: ["Q1", "Q2"])
    sut.start()
    
    router.answerCallback("A1")
    
    XCTAssertNil(router.routedResult)
  }
  
  func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_routesToResult() {
    let sut = makeSUT(questions: ["Q1", "Q2"])
    sut.start()
    
    router.answerCallback("A1")
    router.answerCallback("A2")
    
    XCTAssertEqual(router.routedResult!, ["Q1": "A1", "Q2": "A2"])
  }

  //MARK: Helpers
  
  func makeSUT(questions: [String]) -> Flow<String, String, RouterSpy> {
    return Flow(questions: questions, router: router)
  }
  
  class RouterSpy: Router {
    
    var routedQuestions: [String] = []
    var routedResult: [String: String]? = nil
    var answerCallback: (String) -> Void = { _ in }
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
      routedQuestions.append(question)
      self.answerCallback = answerCallback
    }
    
    func routeTo(result: [String: String]) {
      routedResult = result
    }
  }
  
}
