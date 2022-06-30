//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Movies
//
//  Created by Gabriel Rodrigues Minucci on 29/06/2022.
//

import UIKit

class LeftAlignedCollectionViewLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // atributes is a list of layout attributes for the elements that are currently being displayed in our fram
        // we firstly get the default attributes by calling the super method
        let attributes = super.layoutAttributesForElements(in: rect)

        // our left margin starts at the left most side (0) + our sectionInset.left
        var leftMargin = sectionInset.left
        
        // maxY holds the lowest point of the target item. Think on this property as a way to check
        // if we are still at the same row or if we are at the next row. It starts with -1 so we will
        // properly execute the code at the first row (which will be height 0)
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            // layoutAttribute.frame.origin.y is the y position of the current item we are iterating. If that is
            // bigger than currently stored maxY means that we arrived in a new row
            if layoutAttribute.frame.origin.y >= maxY {
                // when in a new row, the left space will be back the sectionInset.left
                leftMargin = sectionInset.left
            }
            
            // we set the current item left space being the leftMargin
            layoutAttribute.frame.origin.x = leftMargin

            // then we update the left margin to now include the item + spacing
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            
            // maxY will now be set to the item lowest Y position, meaning that as long as the next item
            // origin.y is not bigger that this we know that we are still in the same row (to keep adding to the leftMargin)
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
