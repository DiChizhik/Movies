//
//  CoreDataWatchlistService.swift
//  Movies
//
//  Created by Diana Chizhik on 09/09/2022.
//
import CoreData
import FirebaseCrashlytics
import Foundation

private class Container {
    static let shared: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataWatchlistItem")
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

class CoreDataWatchlistService: WatchlistServiceProtocol {
    private let container = Container.shared

    func getStatus(for id: Int, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void) {
        let request = CoreDataWatchlistItem.createFetchRequest()
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
            Crashlytics.crashlytics().record(error: WatchlistServiceError.failedToFetchFromPersistentStore.asNSError)

            completion(.failure(.failedToFetchFromPersistentStore))
        }
    }
    
    func toggleStatus(for item: WatchlistItemProtocol, completion: (Result<WatchlistStatus, WatchlistServiceError>)-> Void) {
        let request = CoreDataWatchlistItem.createFetchRequest()
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
                let watchlistMovie = CoreDataWatchlistItem(context: container.viewContext)
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
            Crashlytics.crashlytics().record(error: WatchlistServiceError.failedToFetchFromPersistentStore.asNSError)
            
            completion(.failure(.failedToFetchFromPersistentStore))
        }
    }

    func getWatchlist(completion: (Result<[WatchlistItem], WatchlistServiceError>)-> Void) {
        let request = CoreDataWatchlistItem.createFetchRequest()
        let sort = NSSortDescriptor(key: "saveDate", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let watchlistMovies = try container.viewContext.fetch(request)
            let watchlistItems =  watchlistMovies.map { WatchlistItem(from: $0)}
            completion(.success(watchlistItems))
        } catch {
            Crashlytics.crashlytics().record(error: WatchlistServiceError.failedToFetchFromPersistentStore.asNSError)
            
            completion(.failure(.failedToFetchFromPersistentStore))
        }
    }
}

//MARK: - Private functions
extension CoreDataWatchlistService {
    private func saveWatchlist(completion: (Result<Bool, WatchlistServiceError>) -> Void) {
        guard container.viewContext.hasChanges else {
            completion(.success(true))
            return
        }
        
        do {
            try container.viewContext.save()
            completion(.success(true))
        } catch {
            Crashlytics.crashlytics().record(error: WatchlistServiceError.failedToSaveToPersistentStore.asNSError)
            
            completion(.failure(.failedToSaveToPersistentStore))
        }
    }
}
