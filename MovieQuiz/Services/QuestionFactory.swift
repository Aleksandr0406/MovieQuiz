//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by 1111 on 10.09.2024.
//

import Foundation
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    if mostPopularMovies.items.isEmpty {
                        self.delegate?.didFailToLoadData()
                    } else {
                        self.movies = mostPopularMovies.items
                        self.delegate?.didLoadDataFromServer()
                    }
                case .failure:
                    self.delegate?.didFailToLoadData()
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    delegate?.didFailToLoadData()
                }
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let questionsAndRating = ["Рейтинг этого фильма больше чем 7?" : rating > 7,
                                      "Рейтинг этого фильма больше чем 8?" : rating > 8,
                                      "Рейтинг этого фильма больше чем 9?" : rating > 9,
                                      "Рейтинг этого фильма меньше чем 7?" : rating < 7,
                                      "Рейтинг этого фильма меньше чем 8?" : rating < 8,
                                      "Рейтинг этого фильма меньше чем 9?" : rating < 9
            ]
            
            guard let text = questionsAndRating.keys.randomElement() else { return }
            guard let correctAnswer = questionsAndRating[text] else { return }

            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
