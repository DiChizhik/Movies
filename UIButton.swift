//
//  UIButton.swift
//  Movies
//
//  Created by Diana Chizhik on 20.07.22.
//

import UIKit

extension UIButton {
    func setInsets(forContentPadding contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left,
            bottom: contentPadding.bottom,
            right: contentPadding.right + imageTitlePadding
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
           )
    }
    
    static func createWatchlistButton()-> UIButton {
        var config = UIButton.Configuration.plain()
        
        config.title = "To Watchlist"
        config.titleTextAttributesTransformer =
          UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15)
            outgoing.foregroundColor = .whiteF5
            return outgoing
        }
        
        config.image = #imageLiteral(resourceName: "ticket")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.imageColorTransformer = UIConfigurationColorTransformer { incoming in
            var outgoing = incoming
            outgoing = .lightBlue61
            return outgoing
        }

        let button = UIButton(configuration: config)
        return button
    }
    
    func updateWatchlistButton(isOnWatchlist: Bool) {
        var config = self.configuration
        config?.title = isOnWatchlist ? "On Watchlist" : "To Watchlist"
        config?.imageColorTransformer = UIConfigurationColorTransformer { incoming in
            var outgoing = incoming
            outgoing = isOnWatchlist ? .green : .lightBlue61
            return outgoing
        }
        self.configuration = config
    }
    
}
