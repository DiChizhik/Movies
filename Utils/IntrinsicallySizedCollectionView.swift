//
//  IntrinsicallySizedCollectionView.swift
//  Movies
//
//  Created by Gabriel Rodrigues Minucci on 29/06/2022.
//

import UIKit

class IntrinsicallySizedCollectionView: UICollectionView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        return contentSize
    }
}
