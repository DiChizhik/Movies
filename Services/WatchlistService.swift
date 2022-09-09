//
//  WatchlistService.swift
//  Movies
//
//  Created by Diana Chizhik on 21.07.22.
//

import UIKit

protocol WatchlistServiceProtocol {
    func getStatus(for id: Int, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void)
    func toggleStatus(for item: WatchlistItemProtocol, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void)
    func getWatchlist(completion: (Result<[WatchlistItem], WatchlistServiceError>)-> Void)
}

enum WatchlistStatus {
    case added, notAdded
}

enum WatchlistServiceError: Int, Error, ErrorViewHandleable {
    case failedToFetchFromPersistentStore = 1
    case failedToSaveToPersistentStore = 2
    case failedToDecodeDataFromUserDefaults = 3
    case failedToEncodeDataToUserDefaults = 4
    
    var errorTitle: String {
        switch self {
        case .failedToFetchFromPersistentStore, .failedToSaveToPersistentStore, .failedToDecodeDataFromUserDefaults, .failedToEncodeDataToUserDefaults:
            return "Houston, we have a problem.\nClose and re-open the app."
        }
    }
    
    var errorImage: UIImage? {
        switch self {
        case .failedToFetchFromPersistentStore, .failedToSaveToPersistentStore, .failedToDecodeDataFromUserDefaults, .failedToEncodeDataToUserDefaults:
            return #imageLiteral(resourceName: "dizzy")
        }
    }
    
    var asNSError: NSError {
            NSError(domain: "WatchlistServiceErrorDomain", code: rawValue, userInfo: nil)
        }
}

typealias WatchlistService = CoreDataWatchlistService
//typealias WatchlistService = UserDefaultsWatchlistService



