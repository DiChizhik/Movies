//
//  WatchlistItem.swift
//  Movies
//
//  Created by Diana Chizhik on 17/08/2022.
//

import Foundation


protocol WatchlistItemProtocol {
    var id: Int { get }
    var title: String { get }
    var voteAverage: Int { get }
    var posterPath: URL? { get }
    
//    init(movie: CoreDataHandleable) {
//        self.id = Int32(movie.id)
//        self.saveDate = Date.now
//        self.title = movie.title
//        self.voteAverage = Int16(movie.voteAverage)
//        self.posterPath = movie.posterPath
//    }
//
//    init(movie: WatchlistMovie) {
//        self.id = movie.id
//        self.saveDate = movie.saveDate
//        self.title = movie.title
//        self.voteAverage = movie.voteAverage
//        self.posterPath = movie.posterPath
//    }
}

struct WatchlistItem: Codable, WatchlistItemProtocol {
    var id: Int
    var saveDate: Date
    let title: String
    let voteAverage: Int
    let posterPath: URL?
    
//    init(id: Int, title: String, voteAverage: Int, posterPath: URL?) {
//        self.id = id
//        self.saveDate = Date.now
//        self.title = title
//        self.voteAverage = voteAverage
//        self.posterPath = posterPath
//    }
    
    init(from coreDataWatchlistItem: WatchlistMovie) {
        self.id = Int(coreDataWatchlistItem.id)
        self.saveDate = coreDataWatchlistItem.saveDate
        self.title = coreDataWatchlistItem.title
        self.voteAverage = Int(coreDataWatchlistItem.voteAverage)
        self.posterPath = coreDataWatchlistItem.posterPath
    }
    
    init(from item: WatchlistItemProtocol) {
        self.id = item.id
        self.saveDate = Date.now
        self.title = item.title
        self.voteAverage = item.voteAverage
        self.posterPath = item.posterPath
    }
    
    
}
