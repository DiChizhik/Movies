//
//  StackMovieDetailView.swift
//  Movies
//
//  Created by Gabriel Rodrigues Minucci on 29/06/2022.
//

import UIKit

final class StackMovieDetailView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textAlignment = .center
        label.textColor = UIColor.white
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
    
    private(set) lazy var releasedOnLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "staticTextColor")
        label.text = "Released on"
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "descriptionColor")
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var lastsLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "staticTextColor")
        label.text = "Lasts"
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "descriptionColor")
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var movieDescriptionLabel: UILabel = {
        let description = UILabel()
        description.numberOfLines = 0
        description.font = UIFont.systemFont(ofSize: 15)
        description.textColor = UIColor(named: "descriptionColor")
        description.textAlignment = .left
        return description
    }()
    
    private(set) lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = LeftAlignedCollectionViewLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private(set) lazy var collectionView: IntrinsicallySizedCollectionView = {
        let collectionView = IntrinsicallySizedCollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        return collectionView
    }()
    
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private(set) lazy var scrollContentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
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
        backgroundColor = UIColor(named: "backgroundColor")
        
        // Our scrollview takes over the full view size
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
        ])
        
        // The content view will be constrained to our scrollview size
        scrollView.addSubview(scrollContentStack)
        NSLayoutConstraint.activate([
            scrollContentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            // Here is one of the tricks when using scrollviews. Since we are going to scroll only vertically we set the width to always
            // be the size of the scroll view. This way only height will vary. If we would only scroll horizontally then you fix height instead.
            scrollContentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            // We don't need to specify the height as contentView.subviews will be doing that automatically below
        ])
        
        let releaseStack = UIStackView(arrangedSubviews: [releasedOnLabel, releaseDateLabel])
        releaseStack.translatesAutoresizingMaskIntoConstraints = false
        releaseStack.axis = .horizontal
        releaseStack.alignment = .leading
        releaseStack.spacing = 4
        
        let durationStack = UIStackView(arrangedSubviews: [lastsLabel, durationLabel])
        durationStack.translatesAutoresizingMaskIntoConstraints = false
        durationStack.axis = .horizontal
        durationStack.alignment = .leading
        durationStack.spacing = 4
        
        // This will hold only title and image as they are center aligned
        let centerAlignedStack = UIStackView()
        centerAlignedStack.axis = .vertical
        centerAlignedStack.alignment = .center
        centerAlignedStack.addArrangedSubview(titleLabel)
        centerAlignedStack.addArrangedSubview(imageView, spaceBefore: 16)
        
        scrollContentStack.addArrangedSubview(centerAlignedStack)
        scrollContentStack.addArrangedSubview(releaseStack, spaceBefore: 35)
        scrollContentStack.addArrangedSubview(durationStack, spaceBefore: 8)
        scrollContentStack.addArrangedSubview(movieDescriptionLabel, spaceBefore: 16)
        scrollContentStack.addArrangedSubview(collectionView, spaceBefore: 16)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.41),
            imageView.widthAnchor.constraint(equalTo: scrollContentStack.widthAnchor, multiplier: 0.61)
        ])
    }
}
