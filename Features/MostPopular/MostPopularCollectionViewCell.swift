//
//  CollectionViewCell.swift
//  Movies
//
//  Created by Diana Chizhik on 01/06/2022.
//

import UIKit
import Kingfisher

class MostPopularCollectionViewCell: UICollectionViewCell, Reusable {
    private var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
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
extension MostPopularCollectionViewCell {
    func configure(imageURL: URL?) {
        guard let url = imageURL else { return }
        imageView.kf.setImage(with: url)
    }
}

// MARK: - Private functions
private extension MostPopularCollectionViewCell {
    func setupUI() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
