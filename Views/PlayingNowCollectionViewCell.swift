//
//  PlayingNowCollectionViewCell.swift
//  Movies
//
//  Created by Diana Chizhik on 25/05/2022.
//

import UIKit
import Kingfisher

class PlayingNowCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PlayingNowCollectionViewCell"
    
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
        name.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        name.textAlignment = .left
        name.textColor = UIColor.white
        name.numberOfLines = 1
        name.setContentHuggingPriority(.defaultLow, for: .horizontal)
        name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return name
    }()
    
    private var duration: UILabel = {
       let duration = UILabel()
        duration.translatesAutoresizingMaskIntoConstraints = false
        duration.font = UIFont.systemFont(ofSize: 14)
        duration.textAlignment = .left
        duration.textColor = UIColor(named: "grey")
        return duration
    }()
    
    private lazy var reviewsScore: UILabel = {
       let reviewsScore = UILabel()
        reviewsScore.translatesAutoresizingMaskIntoConstraints = false
        reviewsScore.font = UIFont.systemFont(ofSize: 14)
        reviewsScore.textAlignment = .right
        reviewsScore.textColor = UIColor(named: "grey")
        reviewsScore.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        reviewsScore.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return reviewsScore
    }()
    
    private lazy var reviewsScoreIndicator: UIView = {
        let reviewsScoreIndicator = UIView()
        reviewsScoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        reviewsScoreIndicator.widthAnchor.constraint(equalToConstant: 12).isActive = true
        reviewsScoreIndicator.heightAnchor.constraint(equalTo: reviewsScoreIndicator.widthAnchor).isActive = true
        reviewsScoreIndicator.layer.cornerRadius = 6
        reviewsScoreIndicator.layer.masksToBounds = true
        reviewsScoreIndicator.backgroundColor = UIColor(named: "red")
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

    
    func setupUI() {
        contentView.backgroundColor = UIColor(named: "backgroundColor")
        
        contentView.addSubview(imageView)
        contentView.addSubview(name)
        contentView.addSubview(duration)
        contentView.addSubview(reviewsScore)
        contentView.addSubview(reviewsScoreIndicator)
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.83),
            
            reviewsScore.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            reviewsScore.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            
            reviewsScoreIndicator.rightAnchor.constraint(equalTo: reviewsScore.leftAnchor, constant: -2),
            reviewsScoreIndicator.centerYAnchor.constraint(equalTo: reviewsScore.centerYAnchor),
            
            name.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            name.rightAnchor.constraint(equalTo: reviewsScoreIndicator.leftAnchor),
            name.centerYAnchor.constraint(equalTo: reviewsScore.centerYAnchor),
            
            duration.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            duration.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4),
            duration.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(imageURL: URL, name: String, duration: String, reviewsScore: String) {
        imageView.kf.setImage(with: imageURL)
        self.name.text = name
        self.duration.text = duration
        self.reviewsScore.text = reviewsScore
        
        let score = reviewsScore.components(separatedBy: "%")
        if let scoreInt = Int(score[0]) {
            if scoreInt > 50 {
                reviewsScoreIndicator.backgroundColor = UIColor(named: "green")
            }
        }
    
    }
}
