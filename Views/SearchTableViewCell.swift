//
//  SearchTableViewCell.swift
//  Movies
//
//  Created by Diana Chizhik on 11/07/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell, Reusable {
    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let name = UILabel()
         name.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
         name.textAlignment = .left
         name.textColor = UIColor(named: "titleColor")
         name.numberOfLines = 1
         return name
    }()
    
    private lazy var reviewsScore: UILabel = {
        let reviewsScore = UILabel()
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(named: "backgroundColor")
        
        let reviewStack = UIStackView(arrangedSubviews: [reviewsScoreIndicator, reviewsScore])
        reviewStack.axis = .horizontal
        reviewStack.spacing = 8
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, reviewStack])
        textStack.translatesAutoresizingMaskIntoConstraints = false
        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.alignment = .leading
        
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(textStack)
        
        
        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            posterImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.65),

            textStack.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            textStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20)
        ])
    }
    
    func configure(imageURL: URL?, title: String, reviewsScore: Int, popularity: Movie.Popularity) {
        if let url = imageURL {
            posterImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = title
        self.reviewsScore.text = "\(reviewsScore)%"
        
        reviewsScoreIndicator.image = popularity == .high ? UIImage(named: "highReviewsScore") : UIImage(named: "lowReviewsScore")
    }

}
