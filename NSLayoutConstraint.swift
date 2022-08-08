//
//  NSLayoutConstraint.swift
//  Movies
//
//  Created by Diana Chizhik on 1.08.22.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    struct SuperviewCorners {
        let topLeft: Bool
        let topRight: Bool
        let bottomLeft: Bool
        let bottomRight: Bool
    }
    
    static func pin(_ subview: UIView, to corners: SuperviewCorners, withInsets insets: UIEdgeInsets) {
        guard let superview = subview.superview else { return }
            
        subview.translatesAutoresizingMaskIntoConstraints = false
            
        if corners.topLeft == true {
            subview.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
            subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
        }
            
        if corners.topRight == true {
            subview.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
            subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
        }
            
        if corners.bottomLeft == true {
            subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left).isActive = true
            subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
        }
            
        if corners.bottomRight == true {
            subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right).isActive = true
            subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
        }
    }
}
