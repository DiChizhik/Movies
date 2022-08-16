//
//  ReviewScoreStackView.swift
//  Movies
//
//  Created by Diana Chizhik on 20.07.22.
//

import UIKit

final class ReviewScoreStackView: UIStackView {
    private lazy var reviewsScore: UILabel = {
       let reviewsScore = UILabel()
        reviewsScore.translatesAutoresizingMaskIntoConstraints = false
        reviewsScore.font = UIFont.systemFont(ofSize: 15)
        reviewsScore.textAlignment = .right
        reviewsScore.textColor = .whiteF5
        reviewsScore.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        reviewsScore.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return reviewsScore
    }()
    
    private lazy var reviewsScoreIndicator: UIImageView = {
        let reviewsScoreIndicator = UIImageView()
        reviewsScoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        reviewsScoreIndicator.heightAnchor.constraint(equalToConstant: 15).isActive = true
        reviewsScoreIndicator.widthAnchor.constraint(equalTo: reviewsScoreIndicator.heightAnchor, multiplier: 1.13).isActive = true
        reviewsScoreIndicator.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        reviewsScoreIndicator.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return reviewsScoreIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public functions
extension ReviewScoreStackView {
    func setValue(_ scoreValue: Int) {
        reviewsScore.text = "\(scoreValue)%"
    
        reviewsScoreIndicator.image = scoreValue > 50 ? #imageLiteral(resourceName: "highReviewsScore") : #imageLiteral(resourceName: "lowReviewsScore")
    }
}

// MARK: - Private functions
private extension ReviewScoreStackView {
    func setupUI() {
        axis = .horizontal
        spacing = 8
        
        addArrangedSubview(reviewsScoreIndicator)
        addArrangedSubview(reviewsScore)
    }
}

