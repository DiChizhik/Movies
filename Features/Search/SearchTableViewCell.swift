//
//  SearchTableViewCell.swift
//  Movies
//
//  Created by Diana Chizhik on 11/07/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell, Reusable, WatchlistHandleable {
    weak var watchlistButtonDelegate: WatchlistButtonDelegate?
    
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
        name.textColor = .whiteF5
        name.numberOfLines = 1
        return name
    }()
    
    private lazy var reviewScoreStackView: ReviewScoreStackView = {
        let view = ReviewScoreStackView()
        return view
    }()
    
    lazy var watchlistButton: WatchlistButton = {
        let button = WatchlistButton()
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            
            self.watchlistButtonDelegate?.watchlistTapped(self)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
}

// MARK: - Public functions
extension SearchTableViewCell {
    func configure(imageURL: URL?, title: String, reviewsScore: Int, status: WatchlistStatus?) {
        if let url = imageURL {
            posterImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = title
        reviewScoreStackView.setValue(reviewsScore)
        
        if let status = status {
            watchlistButton.updateWithStatus(status, isShortVariant: false)
        }
    }
}

// MARK: - Private functions
private extension SearchTableViewCell {
   func setupUI() {
        contentView.backgroundColor = .darkBlue01
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, reviewScoreStackView])
        textStack.addArrangedSubview(watchlistButton, spaceBefore: 16)
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
}
