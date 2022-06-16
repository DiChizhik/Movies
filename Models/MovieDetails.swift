//
//  MovieDetails.swift
//  Movies
//
//  Created by Diana Chizhik on 15/06/2022.
//

import Foundation

struct MovieDetails: Codable {
    let title: String
    let posterPath: String
    let spokenLanguages: [Language]
    let genres: [Genre]
//    Date type
    let releaseDate: String
    let runtime: Int
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
        case spokenLanguages = "spoken_languages"
        case genres
        case releaseDate = "release_date"
        case runtime
        case overview
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct Language: Codable {
    let englishName: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
    }
}
