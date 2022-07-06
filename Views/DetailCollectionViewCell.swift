//
//  DetailCollectionViewCell.swift
//  Movies
//
//  Created by Diana Chizhik on 23/06/2022.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    static var reuseIdentifier: String { NSStringFromClass(self) }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.text = "Gibberish"
        label.textColor = UIColor(named: "descriptionColor")
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
    
    private func setupUI() {
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
    
    func configure(title: String, backgroundColor: UIColor, borderColor: UIColor) {
        label.text = title
        
        contentView.backgroundColor = backgroundColor
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = borderColor.cgColor
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
    }
}
