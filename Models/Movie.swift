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

struct Movie: Decodable, WatchlistItemProtocol {
    let id: Int
    let posterPath: URL?
    let overview: String?
    let title: String
    let voteAverage: Int
    
    enum CodingKeys: String, CodingKey {
        case id, overview, title, reviewsScore
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        
        if let posterPathString = try values.decodeIfPresent(String.self, forKey: .posterPath) {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "image.tmdb.org"
            urlComponents.path = "/t/p/w500\(posterPathString)"
            
            posterPath = urlComponents.url
        } else {
            posterPath = nil
        }
        
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        title = try values.decode(String.self, forKey: .title)
        voteAverage = Int(try values.decode(Double.self, forKey: .voteAverage) * 10)
    }
}
