//
//  ErrorView.swift
//  Movies
//
//  Created by Diana Chizhik on 18.07.22.
//

import UIKit

protocol ErrorViewDelegate: AnyObject {
    func dismissController()
}

class ErrorView: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        return imageView
    }()
    
    lazy var errorLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "errorTextColor")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dismissButton: UIButton = {
       let button = UIButton()
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor(named: "dismissButtonColor")!,
            .font : UIFont.systemFont(ofSize: 15)
        ]
        let title = NSAttributedString(string: "Dismiss", attributes: attributes)
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        return button
    }()
    
    lazy var spacer: UIView = {
        let spacer = UIView()
        return spacer
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 24
        view.alignment = .fill
        view.layoutMargins = UIEdgeInsets(top: 24, left: 32, bottom: 16, right: 32)
        view.isLayoutMarginsRelativeArrangement = true
        view.backgroundColor = UIColor(named: "errorViewBackgroundColor")
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .fill
        return view
    }()
    
    weak var delegate: ErrorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
//        At this point I'd talk to the designer about how cruial the background with 0.6 opacity is.
        backgroundColor = UIColor.clear
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.76),
            stackView.heightAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.8)
        ])
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(spacer)
        buttonStackView.addArrangedSubview(dismissButton)
    }

    @objc private func dismissController() {
        delegate?.dismissController()
    }

}
