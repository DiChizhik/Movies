//
//  WatchlistService.swift
//  Movies
//
//  Created by Diana Chizhik on 21.07.22.
//

import UIKit

enum WatchlistStatus {
    case added, notAdded
}

class WatchlistService {
    typealias Watchlist = [Int : WatchlistItem]
    
    func getStatus(for id: Int)-> WatchlistStatus? {
        if let watchlist = getWatchlist() {
            return watchlist[id] != nil ? .added : .notAdded
        } else {
            return nil
        }
    }
    
    func toggleStatus(for item: WatchlistItem) -> WatchlistStatus? {
        if var watchlist = getWatchlist() {
            let currentStatus: WatchlistStatus = watchlist[item.id] != nil ? .added : .notAdded
            switch currentStatus {
            case .added:
                watchlist.removeValue(forKey: item.id)
                return saveWatchlist(watchlist) ? .notAdded : nil
            case .notAdded:
                watchlist[item.id] = item
                return saveWatchlist(watchlist) ? .added : nil
            }
        } else {
            let watchlist: Watchlist = [item.id : item]
            return saveWatchlist(watchlist) ? .added : nil
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
        
        if let watchlistData = defaults.object(forKey: "watchlist") as? Data {
            let decoder = JSONDecoder()
            if let watchlist = try? decoder.decode(Watchlist.self, from: watchlistData) {
                return watchlist
            } else {
                print("Failed to decode data")
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
            defaults.set(watchlistData, forKey: "watchlist")
            return true
        } else {
            return false
        }
    }
}
