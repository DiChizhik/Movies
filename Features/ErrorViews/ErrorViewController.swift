//
//  ErrorViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 18.07.22.
//

import UIKit


class ErrorViewController: UIViewController {
    private var error: MovieServiceError
    
    lazy var contentView: ErrorView = {
        let view = ErrorView()
        return view
    }()
    
    init(error: MovieServiceError) {
        self.error = error
        
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
        
        switch error {
        case .failedToGetResponse:
            contentView.imageView.image = UIImage(named: "wifi")
            contentView.errorLabel.text = "Sherlock didn’t find the internet signal.\nPlease try again later."
        case .failedToGetData:
            contentView.imageView.image = UIImage(named: "dizzy")
            contentView.errorLabel.text = "Houston, we have a problem.\nClose and re-open the app."
        case .failedToDecode:
            contentView.imageView.image = UIImage(named: "spy")
            contentView.errorLabel.text = "Failed to decode data.\nCall the special agents."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.dismissButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
    }
    
    @objc private func dismissController() {
        dismiss(animated: true)
    }

}
