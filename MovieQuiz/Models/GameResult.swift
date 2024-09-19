//
//  GamesResult.swift
//  MovieQuiz
//
//  Created by 1111 on 16.09.2024.
//

import Foundation
import UIKit

struct GameResult {
    var correct: Int
    var total: Int
    var date: Date
    
    func isBetterThan(_ anotherCorrect: Int) -> Bool {
        correct <= anotherCorrect
    }
}
