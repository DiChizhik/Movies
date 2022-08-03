//
//  MovieTabBarItem.swift
//  Movies
//
//  Created by Diana Chizhik on 3.08.22.
//

import Foundation
import UIKit

enum MovieTabBarItem: String, CaseIterable {
    case playingNow = "Playing now"
    case mostPopular = "Most popular"
    case watchlist = "Watchlist"
    case search = "Search"
    
    var title: String {
        return self.rawValue
    }
    
    var image: UIImage {
        switch self {
        case .playingNow:
            return #imageLiteral(resourceName: "playingNowIcon")
        case .mostPopular:
            return #imageLiteral(resourceName: "mostRecentIcon")
        case .watchlist:
            return #imageLiteral(resourceName: "ticket")
        case .search:
            return UIImage(systemName: "magnifyingglass.circle")!
        }
    }
    
    var rootViewController: UIViewController {
        switch self {
        case .playingNow:
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 24
            layout.minimumInteritemSpacing = 16
            return PlayingNowCollectionViewController(collectionViewLayout: layout)
        case .mostPopular:
            return MostPopularViewController()
        case .watchlist:
            return WatchlistViewController()
        case .search:
            return SearchViewController()
        }
    }
}
