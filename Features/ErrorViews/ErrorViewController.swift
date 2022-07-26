//
//  ErrorViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 18.07.22.
//

import UIKit


class ErrorViewController: UIViewController, ErrorViewDelegate {
    private var error: Error
    
    lazy var contentView: ErrorView = {
        let view = ErrorView()
        view.delegate = self
        return view
    }()
    
    required init(error: Error) {
        self.error = error
        
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
        
        if let error = error as? MovieServiceError {
            contentView.imageView.image = error.image
            contentView.errorLabel.text = error.errorDescription
        } else {
//            provide behaviour for other errors
        }
    }
    
    @objc func dismissController() {
        dismiss(animated: true)
    }
}

// MARK: - Static functions
extension ErrorViewController {
    static func handleError(_ error: Error, presentingViewController: UIViewController) {
        let vc = self.init(error: error)
        vc.modalPresentationStyle = .pageSheet
        presentingViewController.present(vc, animated: true)
    }
}
