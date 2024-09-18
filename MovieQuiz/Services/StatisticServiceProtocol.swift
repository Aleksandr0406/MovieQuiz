//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by 1111 on 16.09.2024.
//

import Foundation
import UIKit

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}

