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
            guard let self = self,
                  let index = (0..<self.movies.count).randomElement(),
                  let movie = movies[safe: index] else { return }
            
            let question = generateQuestion(for: movie)
            
            DispatchQueue.main.async {
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    private func generateQuestion(for movie: MostPopularMovie) -> QuizQuestion? {
        guard let rating = Float(movie.rating),
              let targetRate = (7...9).randomElement() else { return nil }
        
        let imageData = loadImageData(from: movie.resizedImageURL) ?? Data()
        let isGreaterThan = Bool.random()
        let comparisonText = isGreaterThan ? "больше" : "меньше"
        let correctAnswer = isGreaterThan ? (rating > Float(targetRate)) : (rating < Float(targetRate))
        let text = "Рейтинг этого фильма \(comparisonText) чем \(targetRate)?"
        
        let question = QuizQuestion(
            image: imageData,
            text: text,
            correctAnswer: correctAnswer
        )
        return question
    }
    
    private func loadImageData(from url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.didFailToLoadData()
            }
            print("Failed to load image: \(error)")
            return nil
        }
    }
}
