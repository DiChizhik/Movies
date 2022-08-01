//
//  NSLayoutConstraint.swift
//  Movies
//
//  Created by Diana Chizhik on 1.08.22.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    static func pin(_ subview: UIView, to superview: UIView, withInsets insets: UIEdgeInsets) {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            subview.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            subview.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            subview.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
        ])
    }
}
