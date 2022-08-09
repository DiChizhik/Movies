//
//  LaunchViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 21/06/2022.
//

import UIKit

class LaunchViewController: UIViewController {
    private lazy var contentView: LaunchView = {
        let view = LaunchView()
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view = contentView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
    }
}

// MARK: - Private functions
private extension LaunchViewController {
    func animate() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
            self.contentView.logoImageView.transform = CGAffineTransform(scaleX: 286, y: 286)
                        },
                       completion: { done in
                            if done {
                                UIView.animate(withDuration: 1,
                                               animations: {
                                                    self.contentView.logoImageView.alpha = 0.5
                                                    self.contentView.logoImageView.transform = CGAffineTransform(scaleX: 83, y: 83)
                                                },
                                               completion: { done in
                                                    if done {
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                            self.presentViewController()
                                                        }
                                                    }
                                                })
                            }
                        })
    }
    
    func presentViewController() {
        let tabBarController = MovieTabBarController(items: MovieTabBarItem.allCases )
        
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
}
