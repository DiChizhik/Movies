//
//  MostPopularView.swift
//  Movies
//
//  Created by Diana Chizhik on 04/07/2022.
//

import UIKit

protocol MostPopularViewDelegate: AnyObject {
    func seeMoreTapped(_ mostPopularView: MostPopularView)
    func watchlistTapped(_ view: WatchlistHandleable)
}

final class MostPopularView: UIView, WatchlistHandleable {
    weak var delegate: MostPopularViewDelegate?
    weak var watchlistButtonDelegate: WatchlistButtonDelegate?
    var collectionViewDelegate: UICollectionViewDelegate? {
        get {
            collectionView.delegate
        }
        set {
            collectionView.delegate = newValue
        }
    }
    
    var collectionViewDataSource: UICollectionViewDataSource? {
        get {
            collectionView.dataSource
        }
        set {
            collectionView.dataSource = newValue
        }
    }
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
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
        collectionView.backgroundColor = .darkBlue01
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var name: UILabel = {
       let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textAlignment = .center
        name.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        name.textColor = UIColor.whiteF5
        name.alpha = 0
        return name
    }()
    
    private lazy var reviewScoreStackView: ReviewScoreStackView = {
        let view = ReviewScoreStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var watchlistButton: WatchlistButton = {
        let button = WatchlistButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.contentInsets.trailing = 0
        button.alpha = 0
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            
            self.watchlistButtonDelegate?.watchlistTapped(self)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private lazy var movieDescription: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 3
        description.font = UIFont.systemFont(ofSize: 15)
        description.textColor = .pureWhiteFF
        description.textAlignment = .center
        description.alpha = 0
        return description
    }()
    
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See more", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.tintColor = .whiteF5
        button.alpha = 0
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            
            self.delegate?.seeMoreTapped(self)
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
extension MostPopularView {
    func configureWith(name: String, score: Int, description: String?, status: WatchlistStatus?) {
        self.name.text = name
        reviewScoreStackView.setValue(score)
        
        if let description = description {
            movieDescription.text = description
        }
        
        if let status = status {
            watchlistButton.updateWithStatus(status, isShortVariant: false)
        }
    }
    
    func changeAlpha(to value: CGFloat) {
        name.alpha = value
        reviewScoreStackView.alpha = value
        watchlistButton.alpha = value
        movieDescription.alpha = value
        seeMoreButton.alpha = value
    }
    
//    I've added this function so that we don't need to access the watchlistButton itself to call its updateWithStatus function. However, due to the Handleable protocol I can't make the button private. In this case does this function make sense here?
    func updateWatchlistButtonWithStatus(_ status: WatchlistStatus, isShortVariant: Bool) {
        watchlistButton.updateWithStatus(status, isShortVariant: isShortVariant)
    }
}

// MARK: - Private functions
private extension MostPopularView {
    func setupUI() {
        backgroundColor = .darkBlue01
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.45),
            collectionView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27)
        ])
        
        addSubview(name)
        addSubview(reviewScoreStackView)
        addSubview(watchlistButton)
        addSubview(movieDescription)
        addSubview(seeMoreButton)
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            name.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            name.widthAnchor.constraint(equalTo: collectionView.heightAnchor, multiplier: 0.7),
            
            reviewScoreStackView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 6),
            reviewScoreStackView.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            
            watchlistButton.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            watchlistButton.centerYAnchor.constraint(equalTo: reviewScoreStackView.centerYAnchor),
            
            movieDescription.topAnchor.constraint(equalTo: reviewScoreStackView.bottomAnchor, constant: 24),
            movieDescription.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            movieDescription.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            seeMoreButton.topAnchor.constraint(equalTo: movieDescription.bottomAnchor, constant: 8),
            seeMoreButton.centerXAnchor.constraint(equalTo: name.centerXAnchor)
        ])
    }
}
