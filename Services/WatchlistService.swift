//
//  WatchlistService.swift
//  Movies
//
//  Created by Diana Chizhik on 21.07.22.
//

import UIKit
import CoreData

protocol WatchlistServiceProtocol {
    func getStatus(for id: Int) throws -> WatchlistStatus
    func toggleStatus(for item: WatchlistMovieConfiguration)-> WatchlistStatus
    func getWatchlist() -> [WatchlistMovie]
}

enum WatchlistStatus {
    case added, notAdded
}

enum WatchlistServiceError: Error, ErrorViewHandleable {
    case failedToFetchFromPersistentStore
    
    var errorTitle: String {
        switch self {
        case .failedToFetchFromPersistentStore:
            return "Houston, we have a problem.\nClose and re-open the app."
        }
    }
    
    var errorImage: UIImage? {
        switch self {
        case .failedToFetchFromPersistentStore:
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

class WatchlistService: WatchlistServiceProtocol {
    private let container = Container.shared

    func getStatus(for id: Int) throws -> WatchlistStatus {
        let request = WatchlistMovie.createFetchRequest()
        let predicate = NSComparisonPredicate(format: "id == %@", id as NSNumber)
        request.predicate = predicate
        
        do {
            let movies = try container.viewContext.count(for: request)
            if movies != 0 {
                return .added
            } else {
                return .notAdded
            }
        } catch {
            throw WatchlistServiceError.failedToFetchFromPersistentStore
        }
    }
    
    func toggleStatus(for item: WatchlistMovieConfiguration) -> WatchlistStatus {
        let request = WatchlistMovie.createFetchRequest()
        let predicate = NSComparisonPredicate(format: "id == %@", item.id as NSNumber)
        request.predicate = predicate
        
        do {
            let movies = try container.viewContext.fetch(request)
            
            if let movie = movies.first {
                container.viewContext.delete(movie)
                return saveWatchlist() ? .notAdded : .added
            } else {
                let watchlistMovie = WatchlistMovie(context: container.viewContext)
                watchlistMovie.configure(withData: item)

                return saveWatchlist() ? .added : .notAdded
            }
        } catch {
//            replace with throwing function later
            return saveWatchlist() ? .added : .notAdded
        }
        
    }
    
    func getWatchlist() -> [WatchlistMovie] {
        let request = WatchlistMovie.createFetchRequest()
        let sort = NSSortDescriptor(key: "saveDate", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let watchlistMovies = try container.viewContext.fetch(request)
            return watchlistMovies
        } catch {
            print("Fetch failed")
            return [WatchlistMovie]()
        }
    }
    
    private func saveWatchlist() -> Bool {
        guard container.viewContext.hasChanges else { return true }
        do {
            try container.viewContext.save()
            return true
        } catch {
            print("An error occurred while saving: \(error)")
            return false
        }
    }
}

