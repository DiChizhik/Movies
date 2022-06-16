//
//  File.swift
//  Movies
//
//  Created by Diana Chizhik on 01/06/2022.
//

import Foundation

struct Movies: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let posterPath: String
    let overview: String
    let title: String
    let voteAverage: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case overview
        case title
        case voteAverage = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        posterPath = try values.decode(String.self, forKey: .posterPath)
        overview = try values.decode(String.self, forKey: .overview)
        title = try values.decode(String.self, forKey: .title)
        voteAverage = Int(try values.decode(Double.self, forKey: .voteAverage) * 10)
    }
}
