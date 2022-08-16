//
//  ErrorViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 18.07.22.
//

import UIKit


final class ErrorViewController: UIViewController, ErrorViewDelegate {
    private var error: ErrorViewHandleable
    
    lazy var contentView: ErrorView = {
        let view = ErrorView()
        view.delegate = self
        return view
    }()
    
    required init(error: ErrorViewHandleable) {
        self.error = error
        
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
        
        contentView.imageView.image = error.errorImage
        contentView.errorLabel.text = error.errorTitle
    }
    
    @objc func dismissController(_ errorView: ErrorView) {
        dismiss(animated: true)
    }
}

// MARK: - Static functions
extension ErrorViewController {
    static func handleError(_ error: ErrorViewHandleable, presentingViewController: UIViewController) {
        let vc = self.init(error: error)
        vc.modalPresentationStyle = .overFullScreen
        presentingViewController.present(vc, animated: true)
    }
}
