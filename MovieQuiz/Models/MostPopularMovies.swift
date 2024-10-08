//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by 1111 on 26.09.2024.
//

import Foundation
import UIKit

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
            let urlString = imageURL.absoluteString
            let imageUrlString = urlString.components(separatedBy: "._") [0] + ".V0_UX600.jpg"
            
            guard let newURL = URL(string: imageUrlString) else {
                return imageURL
            }
            return newURL

    }
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
