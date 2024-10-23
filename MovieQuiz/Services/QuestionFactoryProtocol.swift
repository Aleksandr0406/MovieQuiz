//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by 1111 on 11.09.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
    func makeEmptyIndexSave()
}
