//
//  WatchlistService.swift
//  Movies
//
//  Created by Diana Chizhik on 21.07.22.
//

import UIKit

protocol WatchlistServiceProtocol {
    func getStatus(for id: Int)-> WatchlistStatus
    func toggleStatus(for item: WatchlistItem) -> WatchlistStatus
    func getWatchlistItems() -> [WatchlistItem]
}

enum WatchlistStatus {
    case added, notAdded
}

class WatchlistService: WatchlistServiceProtocol {
    typealias Watchlist = [Int : WatchlistItem]
    private static let watchlistKey: String = "watchlist"
    
    func getStatus(for id: Int)-> WatchlistStatus {
        let watchlist = getWatchlist()
        
        return watchlist[id] != nil ? .added : .notAdded
    }
    
    func toggleStatus(for item: WatchlistItem)-> WatchlistStatus {
        var watchlist = getWatchlist()
        
        let currentStatus: WatchlistStatus = watchlist[item.id] != nil ? .added : .notAdded
        switch currentStatus {
        case .added:
            watchlist.removeValue(forKey: item.id)
            return saveWatchlist(watchlist) ? .notAdded : .added
        case .notAdded:
            watchlist[item.id] = item
            return saveWatchlist(watchlist) ? .added : .notAdded
        }
    }
    
    func getWatchlistItems() -> [WatchlistItem] {
        let watchlist = getWatchlist()
        
        var items = [WatchlistItem]()
        for value in watchlist.values {
            items.append(value)
        }

        return items
    }
    
    private func getWatchlist() -> Watchlist {
        let defaults = UserDefaults.standard
        
        if let watchlistData = defaults.object(forKey: WatchlistService.watchlistKey) as? Data {
            let decoder = JSONDecoder()
            if let watchlist = try? decoder.decode(Watchlist.self, from: watchlistData) {
                return watchlist
            } else {
                return Watchlist()
            }
        } else {
            return Watchlist()
        }
    }
    
    private func saveWatchlist(_ list: Watchlist) -> Bool {
        let encoder = JSONEncoder()
        
        if let watchlistData = try? encoder.encode(list) {
            let defaults = UserDefaults.standard
            defaults.set(watchlistData, forKey: WatchlistService.watchlistKey)
            return true
        } else {
            return false
        }
    }
}
