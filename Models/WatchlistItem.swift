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
}

struct WatchlistItem: Codable, WatchlistItemProtocol {
    var id: Int
    var saveDate: Date
    let title: String
    let voteAverage: Int
    let posterPath: URL?
    
    init(from coreDataWatchlistItem: CoreDataWatchlistItem) {
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
