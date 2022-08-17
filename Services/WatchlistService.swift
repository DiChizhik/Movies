//
//  WatchlistService.swift
//  Movies
//
//  Created by Diana Chizhik on 21.07.22.
//

import UIKit
import CoreData

protocol WatchlistServiceProtocol {
    func getStatus(for id: Int, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void)
    func toggleStatus(for item: WatchlistItemProtocol, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void)
    func getWatchlist(completion: (Result<[WatchlistItem], WatchlistServiceError>)-> Void)
}

enum WatchlistStatus {
    case added, notAdded
}

enum WatchlistServiceError: Error, ErrorViewHandleable {
    case failedToFetchFromPersistentStore, failedToSaveToPersistentStore
    case failedToDecodeDataFromUserDefaults, failedToEncodeDataToUserDefaults
    
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
}

private class Container {
    static let shared: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WatchlistMovies")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores {storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        return container
    }()
    
    private init() {
    }
}

//typealias WatchlistService = CoreDataWatchlistService
typealias WatchlistService = UserDefaultsWatchlistService

class CoreDataWatchlistService: WatchlistServiceProtocol {
    private let container = Container.shared

    func getStatus(for id: Int, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void) {
        let request = WatchlistMovie.createFetchRequest()
        let predicate = NSPredicate(format: "id == %d", id)
        request.predicate = predicate
        
        do {
            let movies = try container.viewContext.count(for: request)
            if movies != 0 {
                completion(.success(.added))
            } else {
                completion(.success(.notAdded))
            }
        } catch {
//            report an error
            completion(.failure(.failedToFetchFromPersistentStore))
        }
    }
    
    func toggleStatus(for item: WatchlistItemProtocol, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void) {
        let request = WatchlistMovie.createFetchRequest()
        let predicate = NSPredicate(format: "id == %d", item.id)
        request.predicate = predicate
        
        do {
            let movies = try container.viewContext.fetch(request)
            
            if let movie = movies.first {
                container.viewContext.delete(movie)
                
                saveWatchlist { result in
                    switch result {
                    case .success(let didSaveChanges):
                        didSaveChanges ? completion(.success(.notAdded)) : completion(.success(.added))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                let watchlistMovie = WatchlistMovie(context: container.viewContext)
                watchlistMovie.configure(withData: item)

                saveWatchlist { result in
                    switch result {
                    case .success(let didSaveChanges):
                        didSaveChanges ? completion(.success(.added)) : completion(.success(.notAdded))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
//            report an error
            completion(.failure(.failedToFetchFromPersistentStore))
        }
        
    }
    
    func getWatchlist(completion: (Result<[WatchlistItem], WatchlistServiceError>)-> Void) {
        let request = WatchlistMovie.createFetchRequest()
        let sort = NSSortDescriptor(key: "saveDate", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let watchlistMovies = try container.viewContext.fetch(request)
            let watchlistItems =  watchlistMovies.map { WatchlistItem(from: $0)}
            completion(.success(watchlistItems))
        } catch {
//            report an error
            completion(.failure(.failedToFetchFromPersistentStore))
        }
    }
    
    private func saveWatchlist(completion: (Result<Bool, WatchlistServiceError>) -> Void) {
        guard container.viewContext.hasChanges else {
            completion(.success(true))
            return
        }
        
        do {
            try container.viewContext.save()
            completion(.success(true))
        } catch {
//            report an error
            completion(.failure(.failedToSaveToPersistentStore))
        }
    }
}

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
//        var watchlist = getSavedWatchlist()
//
//        let currentStatus: WatchlistStatus = watchlist[item.id] != nil ? .added : .notAdded
//        switch currentStatus {
//        case .added:
//            watchlist.removeValue(forKey: item.id)
//            return saveWatchlist(watchlist) ? .notAdded : .added
//        case .notAdded:
//            watchlist[item.id] = item
//            return saveWatchlist(watchlist) ? .added : .notAdded
//        }
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
    
    private func getSavedWatchlist(completion: (Result<Watchlist, WatchlistServiceError>)-> Void) {
        let defaults = UserDefaults.standard
        
        if let watchlistData = defaults.object(forKey: UserDefaultsWatchlistService.watchlistKey) as? Data {
            let decoder = JSONDecoder()
            if let watchlist = try? decoder.decode(Watchlist.self, from: watchlistData) {
                completion(.success(watchlist))
            } else {
//              report an error
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
//          report an error
            completion(.failure(.failedToEncodeDataToUserDefaults))
        }
    }
}


