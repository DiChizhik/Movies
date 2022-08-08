//
//  UICollectionView.swift
//  Movies
//
//  Created by Diana Chizhik on 12/07/2022.
//

import UIKit

extension UICollectionView {
    func register<Cell>(_ cellType: Cell.Type) where Cell: UICollectionViewCell, Cell: Reusable {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeue<Cell>(_ cellType: Cell.Type, for indexPath: IndexPath)-> Cell where Cell: UICollectionViewCell, Cell: Reusable {
        return dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as! Cell
    }
}
