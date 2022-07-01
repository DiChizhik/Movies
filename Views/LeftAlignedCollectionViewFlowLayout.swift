//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Movies
//
//  Created by Diana Chizhik on 01/07/2022.
//

import Foundation
import UIKit

class LeftAlighedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        
        var leftMargin = sectionInset.left
        var bottomMargin: CGFloat = -1
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= bottomMargin {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            bottomMargin = max(layoutAttribute.frame.maxY, bottomMargin)
        }
        
        return attributes
    }
}
