//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by 1111 on 11.09.2024.
//

import Foundation
import UIKit

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}

