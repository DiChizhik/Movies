//
//  UIStackView+Extensions.swift
//  Movies
//
//  Created by Gabriel Rodrigues Minucci on 29/06/2022.
//

import UIKit

extension UIStackView {
    /// Adds a spacing between last view and newly added arranged subview
    ///
    /// The spacing will follow the UIStackView axis. For vertical stacks the space will be added above new view, if horizontal
    /// the spacing will be added at the left side of the new view
    ///
    /// - Parameters:
    ///  - subview: The arranged subview to be added
    ///  - spaceBefore: The spacing between last view and view to be added
    func addArrangedSubview(_ subview: UIView, spaceBefore: CGFloat) {
        let lastViewBeforeAddition = arrangedSubviews.last
        addArrangedSubview(subview)
        
        guard let safeLastViewBeforeAddition = lastViewBeforeAddition else { return }
        setCustomSpacing(spaceBefore, after: safeLastViewBeforeAddition)
    }
}
