//
//  Collection.swift
//  Movies
//
//  Created by Diana Chizhik on 28.07.22.
//

import Foundation

extension Collection {
    subscript(safe index: Index)-> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
