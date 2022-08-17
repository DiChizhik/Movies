//
//  MovieDetails.swift
//  Movies
//
//  Created by Diana Chizhik on 15/06/2022.
//

import Foundation


struct MovieDetails: Codable, WatchlistItemProtocol {
    let id: Int
    let title: String
    let posterPath: URL?
    let spokenLanguages: [Language]
    let genres: [Genre]
    let releaseDate: String
    let runtime: String?
    let overview: String?
    let voteAverage: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case spokenLanguages = "spoken_languages"
        case genres
        case releaseDate = "release_date"
        case runtime
        case overview
        case voteAverage = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        
        if let posterPathString = try values.decodeIfPresent(String.self, forKey: .posterPath) {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "image.tmdb.org"
            urlComponents.path = "/t/p/w500\(posterPathString)"
            
            posterPath = urlComponents.url
        } else {
            posterPath = nil
        }
        
        spokenLanguages = try values.decode([Language].self, forKey: .spokenLanguages)
        genres = try values.decode([Genre].self, forKey: .genres)
        
        if let decodedDate = try? values.decode(Date.self, forKey: .releaseDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            releaseDate = dateFormatter.string(from: decodedDate)
        } else {
            releaseDate = "-"
        }
        
        if let runtimeInt = try values.decodeIfPresent(Int.self, forKey: .runtime) {
            runtime = "\(Int(runtimeInt / 60))h \(runtimeInt % 60)min"
        } else {
            runtime = nil
        }
        
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        
        voteAverage = Int(try values.decode(Double.self, forKey: .voteAverage) * 10)
    }
}

struct Genre: Codable {
    let name: String
}

struct Language: Codable {
    let englishName: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
    }
}
