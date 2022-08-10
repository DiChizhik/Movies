//
//  WatchlistMovie+CoreDataProperties.swift
//  Movies
//
//  Created by Diana Chizhik on 10/08/2022.
//
//

import Foundation
import CoreData

struct WatchlistMovieConfiguration {
    var id: Int32
    var saveDate: Date
    let title: String
    let voteAverage: Int16
    let posterPath: URL?
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

}

extension WatchlistMovie : Identifiable {

}
