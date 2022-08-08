//
//  WatchlistItem.swift
//  Movies
//
//  Created by Diana Chizhik on 21.07.22.
//

import Foundation

struct WatchlistItem: Codable {
    var id: Int
    var saveDate: Date
    let title: String
    let voteAverage: Int
    let posterPath: URL?
}
