//
//  WatchlistMovie+CoreDataProperties.swift
//  Movies
//
//  Created by Diana Chizhik on 10/08/2022.
//
//

import Foundation
import CoreData


extension WatchlistMovie {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<WatchlistMovie> {
        return NSFetchRequest<WatchlistMovie>(entityName: "WatchlistMovie")
    }

    @NSManaged public var id: Int32
    @NSManaged public var saveDate: Date
    @NSManaged public var title: String
    @NSManaged public var voteAverage: Int16
    @NSManaged public var posterPath: URL?

    func configure(withData movieData: WatchlistItemProtocol) {
        self.id = Int32(movieData.id)
        self.saveDate = Date.now
        self.title = movieData.title
        self.voteAverage = Int16(movieData.voteAverage)
    }
}

extension WatchlistMovie : Identifiable {

}
