//
//  Reusable.swift
//  Movies
//
//  Created by Gabriel Rodrigues Minucci on 06/07/2022.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    // https://forums.swift.org/t/relying-on-string-describing-to-get-the-name-of-a-type/16391
    static var reuseIdentifier: String { NSStringFromClass(self) }
}

// MARK: - Table View convenience methods

extension UITableView {
    func register<Cell>(_ cellType: Cell.Type) where Cell: UITableViewCell, Cell: Reusable {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeue<Cell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: UITableViewCell, Cell: Reusable {
        // It's better to have the app crashing here. If we can't load the cell it means that we forgot to register it somewhere,
        // a regression test would catch this "problem" if the developer didn't found it yet. Worst case scenario it's better a
        // app crashing than an empty and useless list of nothing.
        return dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! Cell
    }
}

extension UITableView {
    func register<Cell>(_ cellType: Cell.Type) where Cell: UITableViewHeaderFooterView, Cell: Reusable {
        register(cellType, forHeaderFooterViewReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeueHeaderFooter<Cell>(_ cellType: Cell.Type) -> Cell where Cell: UITableViewHeaderFooterView, Cell: Reusable {
        // It's better to have the app crashing here. If we can't load the cell it means that we forgot to register it somewhere,
        // a regression test would catch this "problem" if the developer didn't found it yet. Worst case scenario it's better a
        // app crashing than an empty and useless list of nothing.
        return dequeueReusableHeaderFooterView(withIdentifier: cellType.reuseIdentifier) as! Cell
    }
}

// MARK: - Collection View convenience methods

extension UICollectionView {
    func register<Cell>(_ cellType: Cell.Type) where Cell: UICollectionViewCell, Cell: Reusable {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeue<Cell>(_ cellType: Cell.Type, for indexPath: IndexPath) -> Cell where Cell: UICollectionViewCell, Cell: Reusable {
        // It's better to have the app crashing here. If we can't load the cell it means that we forgot to register it somewhere,
        // a regression test would catch this "problem" if the developer didn't found it yet. Worst case scenario it's better a
        // app crashing than an empty and useless list of nothing.
        return dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as! Cell
    }
}
