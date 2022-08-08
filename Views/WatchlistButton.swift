//
//  WatchListButton.swift
//  Movies
//
//  Created by Diana Chizhik on 20.07.22.
//

import UIKit

protocol WatchlistButtonDelegate: AnyObject {
    func watchlistTapped(_ view: WatchlistHandleable)
}

protocol WatchlistHandleable: AnyObject {
    var watchlistButtonDelegate: WatchlistButtonDelegate? { get set }
    var watchlistButton: WatchlistButton { get }
}

final class WatchlistButton: UIButton {
    private var selectedText: String? = "On Watchlist"
    private var nonSelectedText: String? = "To Watchlist"
    
    private var image = #imageLiteral(resourceName: "ticket")
    private var selectedColor: UIColor = .green
    private var nonSelectedColor: UIColor = .lightBlue61
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var config = UIButton.Configuration.plain()
        
        config.title = nonSelectedText
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

        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWithStatus(_ status: WatchlistStatus, isShortVariant: Bool) {
        var config = self.configuration
        
        if isShortVariant == false {
            config?.title = status == .added ? selectedText : nonSelectedText
        }
        
        config?.imageColorTransformer = UIConfigurationColorTransformer { incoming in
            var outgoing = incoming
            outgoing = status == .added ? .green : .lightBlue61
            return outgoing
        }
        self.configuration = config
    }
    
    func short() {
        var config = self.configuration
        
        config?.title = nil
        config?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        self.configuration = config
    }
}
