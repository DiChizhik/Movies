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
    func getWatchlistItems() -> [WatchlistItem]?
}

enum WatchlistStatus {
    case added, notAdded
}

class WatchlistService {
    typealias Watchlist = [Int : WatchlistItem]
    static let watchlistKey: String = "watchlist"
    
    func getStatus(for id: Int)-> WatchlistStatus {
        if let watchlist = getWatchlist() {
            return watchlist[id] != nil ? .added : .notAdded
        } else {
            return .notAdded
        }
    }
    
    func toggleStatus(for item: WatchlistItem)-> WatchlistStatus {
        if var watchlist = getWatchlist() {
            let currentStatus: WatchlistStatus = watchlist[item.id] != nil ? .added : .notAdded
            switch currentStatus {
            case .added:
                watchlist.removeValue(forKey: item.id)
                return saveWatchlist(watchlist) ? .notAdded : .added
            case .notAdded:
                watchlist[item.id] = item
                return saveWatchlist(watchlist) ? .added : .notAdded
            }
        } else {
            let watchlist: Watchlist = [item.id : item]
            return saveWatchlist(watchlist) ? .added : .notAdded
        }
    }
    
    func getWatchlistItems() -> [WatchlistItem]? {
        guard let watchlist = getWatchlist() else { return nil }
        
        var items = [WatchlistItem]()
        for value in watchlist.values {
            items.append(value)
        }

        return items
    }
    
    private func getWatchlist() -> Watchlist? {
        let defaults = UserDefaults.standard
        
        if let watchlistData = defaults.object(forKey: WatchlistService.watchlistKey) as? Data {
            let decoder = JSONDecoder()
            if let watchlist = try? decoder.decode(Watchlist.self, from: watchlistData) {
                return watchlist
            } else {
                return nil
            }
        } else {
            return nil
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
