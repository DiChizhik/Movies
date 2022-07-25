//
//  WatchListButton.swift
//  Movies
//
//  Created by Diana Chizhik on 20.07.22.
//

import UIKit
// I planned to delete this implementation of the button and replace it with methods from the UIButton extension. However, it'd be great to discuss both.

final class WatchlistButton: UIButton {
    private var attributes: [NSAttributedString.Key : Any] = [
        .foregroundColor : UIColor.whiteF5,
        .font : UIFont.systemFont(ofSize: 15)
    ]
    private var selectedText: String? = "On Watchlist"
    private var nonSelectedText: String? = "To Watchlist"
    
//    var selectedImage = UIImage(named: "ticket")?.withTintColor(.lightBlue)
    private var image = #imageLiteral(resourceName: "ticket")
    
    var isActive: Bool = false
    
    override func draw(_ rect: CGRect) {
        if isActive {
            setSelected()
        } else {
            setNonSelected()
        }
        
        setInsets(forContentPadding: UIEdgeInsets.zero, imageTitlePadding: 8)
        
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    private func setSelected() {
        setImage(image, for: .normal)
        imageView?.tintColor = .green
        if let selectedText = selectedText {
            setAttributedTitle(NSAttributedString(string: selectedText, attributes: attributes), for: .normal)
        }
    }
    
    private func setNonSelected() {
        setImage(image, for: .normal)
        imageView?.tintColor = .lightBlue61
        if let nonSelectedText = nonSelectedText {
            setAttributedTitle(NSAttributedString(string: nonSelectedText, attributes: attributes), for: .normal)
        }
    }
    
    @objc func tapped() {
        isActive = !isActive
        
        if isActive {
            setSelected()
        } else {
            setNonSelected()
        }
    }
    
    func shortVersion() {
        selectedText = nil
        nonSelectedText = nil
        setInsets(forContentPadding: UIEdgeInsets.zero, imageTitlePadding: 0)
    }
}
