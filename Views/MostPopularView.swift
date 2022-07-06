//
//  MostPopularView.swift
//  Movies
//
//  Created by Diana Chizhik on 04/07/2022.
//

import UIKit

protocol MostPopularViewDelegate: AnyObject {
    func seeMoreTapped()
}

class MostPopularView: UIView {
    private(set) lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 32
        layout.minimumLineSpacing = 30
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MostPopularCollectionViewCell.self)
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        return collectionView
    }()
    
    private(set) var name: UILabel = {
       let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .center
        name.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        name.textColor = UIColor(named: "titleColor")
        name.alpha = 0
        return name
    }()
    
    private(set) var reviewsScore: UILabel = {
       let reviewsScore = UILabel()
        reviewsScore.translatesAutoresizingMaskIntoConstraints = false
        reviewsScore.font = UIFont.systemFont(ofSize: 15)
        reviewsScore.textColor = UIColor(named: "titleColor")
        reviewsScore.alpha = 0
        return reviewsScore
    }()
    
    private(set) lazy var reviewsScoreIndicator: UIImageView = {
        let reviewsScoreIndicator = UIImageView()
        reviewsScoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        reviewsScoreIndicator.heightAnchor.constraint(equalToConstant: 15).isActive = true
        reviewsScoreIndicator.widthAnchor.constraint(equalTo: reviewsScoreIndicator.heightAnchor, multiplier: 1.13).isActive = true
        reviewsScoreIndicator.alpha = 0
        return reviewsScoreIndicator
    }()
    
    private(set) lazy var movieDescription: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 3
        description.font = UIFont.systemFont(ofSize: 15)
        description.textColor = UIColor(named: "descriptionColor")
        description.textAlignment = .center
        description.alpha = 0
        return description
    }()
    
    private(set) lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(seeMoreTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See more", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.tintColor = UIColor(named: "titleColor")
        button.alpha = 0
        return button
    }()
    
    weak var delegate:MostPopularViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
 
    private func setupUI() {
        backgroundColor = UIColor(named: "backgroundColor")
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.45),
            collectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27)
        ])
        
        addSubview(name)
        addSubview(reviewsScore)
        addSubview(reviewsScoreIndicator)
        addSubview(movieDescription)
        addSubview(seeMoreButton)
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            name.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            name.widthAnchor.constraint(equalTo: collectionView.heightAnchor, multiplier: 0.7),
            
            reviewsScore.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 6),
            reviewsScore.centerXAnchor.constraint(equalTo: name.centerXAnchor, constant: 12),
            
            reviewsScoreIndicator.centerYAnchor.constraint(equalTo: reviewsScore.centerYAnchor),
            reviewsScoreIndicator.trailingAnchor.constraint(equalTo: reviewsScore.leadingAnchor, constant: -8),
            
            movieDescription.topAnchor.constraint(equalTo: reviewsScore.bottomAnchor, constant: 24),
            movieDescription.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            movieDescription.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            seeMoreButton.topAnchor.constraint(equalTo: movieDescription.bottomAnchor, constant: 8),
            seeMoreButton.centerXAnchor.constraint(equalTo: name.centerXAnchor)
        ])
    }
    
    @objc private func seeMoreTapped(_ sender: UIButton) {
        delegate?.seeMoreTapped()
    }
}


