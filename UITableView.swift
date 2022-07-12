//
//  UITableView.swift
//  Movies
//
//  Created by Diana Chizhik on 12/07/2022.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String { NSStringFromClass(self) }
}

extension UITableView {
    func register<Cell>(_ cellType: Cell.Type) where Cell: UITableViewCell, Cell: Reusable {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeue<Cell>(_ cellType: Cell.Type, for indexPath: IndexPath)-> Cell where Cell: UITableViewCell, Cell: Reusable {
        return dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! Cell
    }
}
