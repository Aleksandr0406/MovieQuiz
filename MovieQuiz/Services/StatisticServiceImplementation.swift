//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by 1111 on 16.09.2024.
//

import Foundation
import UIKit

final class StatisticServiceImplementation: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case total
        case date
        case correctAnswers
        case totalAccuracy
    }
    var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.correct.rawValue)
            let total = storage.integer(forKey: Keys.total.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.total.rawValue)
            storage.set(newValue.date, forKey: Keys.date.rawValue)
        }
    }
    private var correctAnswers: Int {
        get { storage.integer(forKey: Keys.correctAnswers.rawValue) }
        set { storage.setValue(newValue, forKey: Keys.correctAnswers.rawValue) }
    }
    var totalAccuracy: Double {
        get {  storage.double(forKey: Keys.totalAccuracy.rawValue) }
        set {  storage.set(newValue, forKey: Keys.totalAccuracy.rawValue) }
    }
    
    func store(correct count: Int, total amount: Int) {
        correctAnswers += count
        gamesCount += 1
        bestGame.total += amount
        totalAccuracy = Double(correctAnswers) / (Double(gamesCount) * 10) * 100

        if bestGame.isBetterThan(count) {
            bestGame.correct = count
            bestGame.date = Date()
        }
    }
}
