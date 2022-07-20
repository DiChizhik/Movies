//
//  PlayingNowCollectionViewCell.swift
//  Movies
//
//  Created by Diana Chizhik on 25/05/2022.
//

import UIKit
import Kingfisher

class PlayingNowCollectionViewCell: UICollectionViewCell, Reusable {
    private var imageView: UIImageView = {
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
    
    private lazy var watchlistButton: WatchlistButton = {
        let button = WatchlistButton()
        button.translatesAutoresizingMaskIntoConstraints = false
//      Need to figure out how to get rid of right inset
        button.shortVersion()
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

    
    private func setupUI() {
        contentView.backgroundColor = .backgroundColor
        
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
    
    func configure(imageURL: URL?, name: String, reviewsScore: Int, popularity: Movie.Popularity) {
        if let url = imageURL {
            imageView.kf.setImage(with: url)
        }
        self.name.text = name
        self.reviewScoreStackView.setValue(reviewsScore)
    }
}
