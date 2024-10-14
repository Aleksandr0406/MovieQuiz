//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by 1111 on 26.09.2024.
//

import Foundation
import UIKit

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading  {
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var mostPopularMoviesUrl: URL? {
        URL(string: Constants.mostPopularMoviesPath)
    }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        guard let url = mostPopularMoviesUrl else { return }
        networkClient.fetch(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

extension MoviesLoader {
    enum Constants {
        static let mostPopularMoviesPath = "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf"
    }
}
