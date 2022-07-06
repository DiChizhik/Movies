//
//  UIStackView.swift
//  Movies
//
//  Created by Diana Chizhik on 01/07/2022.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubview(_ subview: UIView, spaceBefore: CGFloat) {
        let lastViewBeforeAdding = arrangedSubviews.last
        addArrangedSubview(subview)
        
        guard let safeLastViewBeforeAdding = lastViewBeforeAdding else { return }
        setCustomSpacing(spaceBefore, after: safeLastViewBeforeAdding)
    }
}
