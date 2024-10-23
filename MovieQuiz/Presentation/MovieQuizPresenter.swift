//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by 1111 on 07.10.2024.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    var questionFactory: QuestionFactoryProtocol?
    private let statisticService: StatisticServiceProtocol!
    private var viewController: (MovieQuizViewControllerProtocol)? = MovieQuizViewController()
    
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    init(viewController: MovieQuizViewControllerProtocol = MovieQuizViewController()) {
        self.viewController = viewController
        
        statisticService = StatisticServiceImplementation()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData() {
        viewController?.hideLoadingIndicator()
        
        let viewModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.questionFactory?.loadData()
            }
        )
        viewController?.showAlert(quiz: viewModel)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer { correctAnswers += 1 }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                                             question: model.text,
                                             questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        viewController?.showLoadingIndicator()
        viewController?.deleteBorderAfterAnswer()
        
        if isLastQuestion() {
            questionFactory?.makeEmptyIndexSave()
            let viewModel = AlertModel(
                title: "Раунд окончен!",
                message: makeResultsMessage(),
                buttonText: "Сыграть еще раз",
                completion: { [weak self] in
                    guard let self = self else { return }
                    self.restartGame()
                }
            )
            viewController?.showAlert(quiz: viewModel)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func makeResultsMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let text = correctAnswers == questionsAmount ?
        "Поздравляем, вы ответили на 10 из 10!\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString)\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%" :
        "Ваш результат: \(correctAnswers)/10\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        return text
    }
}
