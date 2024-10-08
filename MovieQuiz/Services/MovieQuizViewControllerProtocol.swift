//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by 1111 on 08.10.2024.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showAlert(quiz: AlertModel)
    
    func deleteBorderAfterAnswer()
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
}
