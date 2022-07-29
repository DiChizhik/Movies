//
//  PlayingNowCollectionViewCell.swift
//  Movies
//
//  Created by Diana Chizhik on 25/05/2022.
//

import UIKit
import Kingfisher

class PlayingNowCollectionViewCell: UICollectionViewCell, Reusable, WatchlistHandleable {
    weak var watchlistButtonDelegate: WatchlistButtonDelegate?
    
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var name: UILabel = {
       let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        name.textAlignment = .left
        name.textColor = UIColor.whiteF5
        name.numberOfLines = 1
        name.setContentHuggingPriority(.defaultLow, for: .horizontal)
        name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return name
    }()
    
    private lazy var reviewScoreStackView: ReviewScoreStackView = {
        let view = ReviewScoreStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var watchlistButton: WatchlistButton = {
        let button = WatchlistButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.short()
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            
            self.watchlistButtonDelegate?.watchlistTapped(self)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
}

// MARK: - Public functions
extension PlayingNowCollectionViewCell {
    func configure(imageURL: URL?, name: String, reviewsScore: Int, status: WatchlistStatus?) {
        if let url = imageURL {
            imageView.kf.setImage(with: url)
        }
        self.name.text = name
        self.reviewScoreStackView.setValue(reviewsScore)
        
        if let status = status {
            self.watchlistButton.updateWithStatus(status, isShortVariant: true)
        }
    }
}

// MARK: - Private functions
private extension PlayingNowCollectionViewCell {
    func setupUI() {
        contentView.backgroundColor = .darkBlue01
        
        contentView.addSubview(imageView)
        contentView.addSubview(name)
        contentView.addSubview(reviewScoreStackView)
        contentView.addSubview(watchlistButton)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.83),
            
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            reviewScoreStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            reviewScoreStackView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            reviewScoreStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            watchlistButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            watchlistButton.heightAnchor.constraint(equalTo: reviewScoreStackView.heightAnchor),
            watchlistButton.centerYAnchor.constraint(equalTo: reviewScoreStackView.centerYAnchor)
        ])
    }
}
