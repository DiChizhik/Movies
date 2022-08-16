//
//  WatchlistMovie+CoreDataProperties.swift
//  Movies
//
//  Created by Diana Chizhik on 10/08/2022.
//
//

import Foundation
import CoreData

protocol CoreDataHandleable {
    var id: Int { get }
    var title: String { get }
    var voteAverage: Int { get }
    var posterPath: URL? { get }
}

struct WatchlistMovieConfiguration {
    let id: Int32
    let saveDate: Date
    let title: String
    let voteAverage: Int16
    let posterPath: URL?
    
    init(movie: CoreDataHandleable) {
        self.id = Int32(movie.id)
        self.saveDate = Date.now
        self.title = movie.title
        self.voteAverage = Int16(movie.voteAverage)
        self.posterPath = movie.posterPath
    }
    
    init(movie: WatchlistMovie) {
        self.id = movie.id
        self.saveDate = movie.saveDate
        self.title = movie.title
        self.voteAverage = movie.voteAverage
        self.posterPath = movie.posterPath
    }
}

extension WatchlistMovie {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<WatchlistMovie> {
        return NSFetchRequest<WatchlistMovie>(entityName: "WatchlistMovie")
    }

    @NSManaged public var id: Int32
    @NSManaged public var saveDate: Date
    @NSManaged public var title: String
    @NSManaged public var voteAverage: Int16
    @NSManaged public var posterPath: URL?

    func configure(withData movieData: WatchlistMovieConfiguration) {
        self.id = movieData.id
        self.saveDate = movieData.saveDate
        self.title = movieData.title
        self.voteAverage = movieData.voteAverage
        self.posterPath = movieData.posterPath
    }
}

extension WatchlistMovie : Identifiable {

}
