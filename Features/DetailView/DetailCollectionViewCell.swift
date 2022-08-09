//
//  DetailCollectionViewCell.swift
//  Movies
//
//  Created by Diana Chizhik on 23/06/2022.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell, Reusable {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .pureWhiteFF
        return label
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
extension DetailCollectionViewCell {
    func configure(title: String, backgroundColor: UIColor, borderColor: UIColor) {
        label.text = title
        
        contentView.backgroundColor = backgroundColor
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = borderColor.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
    }
}

// MARK: - Private functions
private extension DetailCollectionViewCell {
    func setupUI() {
        contentView.addSubview(label)
        
//        I've applied this method only here for starters in case it's not what you meant. I'll roll it out to other views as soon as it's verified.
        NSLayoutConstraint.pin(label,
                               to: NSLayoutConstraint.SuperviewCorners(topLeft: true, topRight: true, bottomLeft: true, bottomRight: true),
                               withInsets: UIEdgeInsets(top: 4, left: 15, bottom: 4, right: 15))
    }
}
