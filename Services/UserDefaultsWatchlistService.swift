//
//  UserDefaultsWatchlistService.swift
//  Movies
//
//  Created by Diana Chizhik on 09/09/2022.
//
import FirebaseCrashlytics
import Foundation

class UserDefaultsWatchlistService: WatchlistServiceProtocol {
    typealias Watchlist = [Int : WatchlistItem]
    private static let watchlistKey: String = "watchlist"
    
    func getStatus(for id: Int, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void) {
        getSavedWatchlist { result in
            switch result {
            case .success(let watchlist):
                let status: WatchlistStatus = watchlist[id] != nil ? .added : .notAdded
                completion(.success(status))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func toggleStatus(for item: WatchlistItemProtocol, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void) {
        getSavedWatchlist { result in
            switch result {
            case .success(var watchlist):
                let currentStatus: WatchlistStatus = watchlist[item.id] != nil ? .added : .notAdded
                
                switch currentStatus {
                case .added:
                    watchlist.removeValue(forKey: item.id)
                    
                    saveWatchlist(watchlist) { result in
                        switch result {
                        case .success(let didSaveChanges):
                            if didSaveChanges {
                                completion(.success(.notAdded))
                            } else {
                                completion(.success(.added))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .notAdded:
                    let watchlistItem = WatchlistItem(from: item)
                    watchlist[watchlistItem.id] = watchlistItem
                    
                    saveWatchlist(watchlist) { result in
                        switch result {
                        case .success(let didSaveChanges):
                            if didSaveChanges {
                                completion(.success(.added))
                            } else {
                                completion(.success(.notAdded))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWatchlist(completion: (Result<[WatchlistItem], WatchlistServiceError>)-> Void) {
        getSavedWatchlist { result in
            switch result {
            case .success(let watchlist):
                var items = [WatchlistItem]()
                for value in watchlist.values {
                    items.append(value)
                }
                items.sort { $0.saveDate > $1.saveDate ? true : false }
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//MARK: - Private functions
extension UserDefaultsWatchlistService {
    private func getSavedWatchlist(completion: (Result<Watchlist, WatchlistServiceError>)-> Void) {
        let defaults = UserDefaults.standard
        
        if let watchlistData = defaults.object(forKey: UserDefaultsWatchlistService.watchlistKey) as? Data {
            let decoder = JSONDecoder()
            if let watchlist = try? decoder.decode(Watchlist.self, from: watchlistData) {
                completion(.success(watchlist))
            } else {
                Crashlytics.crashlytics().record(error: WatchlistServiceError.failedToDecodeDataFromUserDefaults.asNSError)
                
                completion(.failure(.failedToDecodeDataFromUserDefaults))
            }
        } else {
            completion(.success(Watchlist()))
        }
    }
    
    private func saveWatchlist(_ list: Watchlist, completion: (Result<Bool, WatchlistServiceError>)-> Void) {
        let encoder = JSONEncoder()
        
        if let watchlistData = try? encoder.encode(list) {
            let defaults = UserDefaults.standard
            defaults.set(watchlistData, forKey: UserDefaultsWatchlistService.watchlistKey)
            completion(.success(true))
        } else {
            Crashlytics.crashlytics().record(error: WatchlistServiceError.failedToEncodeDataToUserDefaults.asNSError)
            
            completion(.failure(.failedToEncodeDataToUserDefaults))
        }
    }
}
