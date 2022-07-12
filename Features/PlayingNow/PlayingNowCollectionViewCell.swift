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
        name.textColor = UIColor(named: "titleColor")
        name.numberOfLines = 1
        name.setContentHuggingPriority(.defaultLow, for: .horizontal)
        name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return name
    }()
    
    private lazy var reviewsScore: UILabel = {
       let reviewsScore = UILabel()
        reviewsScore.translatesAutoresizingMaskIntoConstraints = false
        reviewsScore.font = UIFont.systemFont(ofSize: 15)
        reviewsScore.textAlignment = .right
        reviewsScore.textColor = UIColor(named: "titleColor")
        reviewsScore.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        reviewsScore.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return reviewsScore
    }()
    
    private lazy var reviewsScoreIndicator: UIImageView = {
        let reviewsScoreIndicator = UIImageView()
        reviewsScoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        reviewsScoreIndicator.heightAnchor.constraint(equalToConstant: 15).isActive = true
        reviewsScoreIndicator.widthAnchor.constraint(equalTo: reviewsScoreIndicator.heightAnchor, multiplier: 1.13).isActive = true
        return reviewsScoreIndicator
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
        contentView.backgroundColor = UIColor(named: "backgroundColor")
        
        contentView.addSubview(imageView)
        contentView.addSubview(name)
        contentView.addSubview(reviewsScore)
        contentView.addSubview(reviewsScoreIndicator)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.83),
            
            name.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            name.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            name.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            reviewsScoreIndicator.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            reviewsScoreIndicator.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            reviewsScoreIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            reviewsScore.leftAnchor.constraint(equalTo: reviewsScoreIndicator.rightAnchor, constant: 8),
            reviewsScore.centerYAnchor.constraint(equalTo: reviewsScoreIndicator.centerYAnchor)
        ])
    }
    
    func configure(imageURL: URL?, name: String, reviewsScore: Int, popularity: Movie.Popularity) {
        if let url = imageURL {
            imageView.kf.setImage(with: url)
        }
        self.name.text = name
        self.reviewsScore.text = "\(reviewsScore)%"
        
        reviewsScoreIndicator.image = popularity == .high ? UIImage(named: "highReviewsScore") : UIImage(named: "lowReviewsScore")
    
    }
}
