//
//  StackMovieDetailView.swift
//  Movies
//
//  Created by Diana Chizhik on 01/07/2022.
//

import UIKit

class StackMovieDetailView: UIView {
    private(set) lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textAlignment = .center
        label.textColor = .whiteF5
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private(set) lazy var reviewScoreStackView: ReviewScoreStackView = {
        let view = ReviewScoreStackView()
        return view
    }()
    
    private lazy var spacer: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private(set) lazy var watchlistButton: WatchlistButton = {
        let button = WatchlistButton()
        return button
    }()
    
    private(set) lazy var releasedOnLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightBlueDB
        label.text = "Released on"
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private(set) lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .pureWhiteFF
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var lastsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightBlueDB
        label.text = "Lasts"
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private(set) lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .pureWhiteFF
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var movieDescriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 0
        description.font = UIFont.systemFont(ofSize: 15)
        description.textColor = .pureWhiteFF
        description.textAlignment = .left
        return description
    }()
    
    private(set) lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
//       consider this
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private(set) lazy var collectionView: SelfSizingCollectionView = {
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DetailCollectionViewCell.self)
        collectionView.backgroundColor = .backgroundColor
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private(set) lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private(set) lazy var scrollContentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
//        consider this
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
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
        backgroundColor = .backgroundColor
        
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollView.addSubview(scrollContentStack)
        
        NSLayoutConstraint.activate([
            scrollContentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let reviewAndWatchlistStack = UIStackView(arrangedSubviews: [reviewScoreStackView, spacer, watchlistButton])
        reviewAndWatchlistStack.translatesAutoresizingMaskIntoConstraints = false
        reviewAndWatchlistStack.axis = .horizontal
        
        let centerAlignedStack = UIStackView()
        centerAlignedStack.translatesAutoresizingMaskIntoConstraints = false
        centerAlignedStack.axis = .vertical
        centerAlignedStack.alignment = .center
        centerAlignedStack.addArrangedSubview(titleLabel)
        centerAlignedStack.addArrangedSubview(imageView, spaceBefore: 16)
        centerAlignedStack.addArrangedSubview(reviewAndWatchlistStack, spaceBefore: 19)
        
        let releaseStack = UIStackView(arrangedSubviews: [releasedOnLabel, releaseDateLabel])
        releaseStack.axis = .horizontal
//        Why do we need .leading here if its description says "a layout for vertical stacks where the stack view aligns the leading edge of its arranged views along its leading edge. This is equivalent to the top alignment for horizontal stacks."
//        releaseStack.alignment = .leading
        releaseStack.spacing = 4
        
        let durationStack = UIStackView(arrangedSubviews: [lastsLabel, durationLabel])
        durationStack.axis = .horizontal
//        durationStack.alignment = .leading
        durationStack.spacing = 4
        
        scrollContentStack.addArrangedSubview(centerAlignedStack)
        scrollContentStack.addArrangedSubview(releaseStack, spaceBefore: 35)
        scrollContentStack.addArrangedSubview(durationStack, spaceBefore: 8)
        scrollContentStack.addArrangedSubview(movieDescriptionLabel, spaceBefore: 16)
        scrollContentStack.addArrangedSubview(collectionView, spaceBefore: 16)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: scrollContentStack.widthAnchor, multiplier: 0.61),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.41),
            
            reviewAndWatchlistStack.widthAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}
