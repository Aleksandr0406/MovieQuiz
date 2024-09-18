//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by 1111 on 12.09.2024.
//

import Foundation
import UIKit

class ResultAlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: MovieQuizViewController?
    
    func presentAlert(quiz result: AlertModel) {
        guard let delegate = delegate
        else { return }
        
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default
        ) { [weak self] _ in
            guard self != nil else { return }
            result.completion()
        }
        
            alert.addAction(action)
            delegate.present(alert, animated: true, completion: nil)
        }
}

