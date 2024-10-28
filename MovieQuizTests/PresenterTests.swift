//
//  PresenterTest.swift
//  MovieQuizTests
//
//  Created by 1111 on 08.10.2024.
//
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showAlert(quiz: AlertModel) {
    }
    
    func deleteBorderAfterAnswer() {
    }
    
    func show(quiz step: QuizStepViewModel) {
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
    }
    
    func showLoadingIndicator() {
    }
    
    func hideLoadingIndicator() {
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
