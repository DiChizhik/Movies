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
        label.textColor = UIColor(named: "titleColor")
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "staticTextColor")
        label.text = "Released on"
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private(set) lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "descriptionColor")
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var lastsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "staticTextColor")
        label.text = "Lasts"
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private(set) lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "descriptionColor")
        label.textAlignment = .left
        return label
    }()
    
    private(set) lazy var movieDescriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 0
        description.font = UIFont.systemFont(ofSize: 15)
        description.textColor = UIColor(named: "descriptionColor")
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
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private(set) lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private(set) lazy var scrollContentStack:UIStackView = {
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
        backgroundColor = UIColor(named: "backgroundColor")
        
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
        
        let centerAlignedStack = UIStackView()
        centerAlignedStack.translatesAutoresizingMaskIntoConstraints = false
        centerAlignedStack.axis = .vertical
        centerAlignedStack.alignment = .center
        centerAlignedStack.addArrangedSubview(titleLabel)
        centerAlignedStack.addArrangedSubview(imageView, spaceBefore: 16)
        
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
        
        scrollContentStack.addArrangedSubview(centerAlignedStack)
        scrollContentStack.addArrangedSubview(releaseStack, spaceBefore: 35)
        scrollContentStack.addArrangedSubview(durationStack, spaceBefore: 8)
        scrollContentStack.addArrangedSubview(movieDescriptionLabel, spaceBefore: 16)
        scrollContentStack.addArrangedSubview(collectionView, spaceBefore: 16)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: scrollContentStack.widthAnchor, multiplier: 0.61),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.41)
        ])
    }
}
