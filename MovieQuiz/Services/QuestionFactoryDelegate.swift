//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by 1111 on 11.09.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData()
}

