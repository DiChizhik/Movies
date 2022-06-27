//
//  File.swift
//  Movies
//
//  Created by Diana Chizhik on 01/06/2022.
//

import Foundation

struct Movies: Decodable {
    var results: [Movie]
}

struct Movie: Decodable {
    enum Popularity {
        case high, low
    }
    
    let id: Int
    let posterPath: URL?
    let overview: String?
    let title: String
    let voteAverage: Int
    let popularity: Popularity
    
    enum CodingKeys: String, CodingKey {
        case id, overview, title, reviewsScore
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        
        if let posterPathString = try values.decodeIfPresent(String.self, forKey: .posterPath) {
            posterPath = URL(string: "https://image.tmdb.org/t/p/w500" + posterPathString)
        } else {
            posterPath = nil
        }
        
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        title = try values.decode(String.self, forKey: .title)
        voteAverage = Int(try values.decode(Double.self, forKey: .voteAverage) * 10)
        
        popularity = voteAverage > 50 ? .high : .low
    }
}
