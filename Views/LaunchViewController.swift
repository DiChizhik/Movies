//
//  LaunchViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 21/06/2022.
//

import UIKit

class LaunchViewController: UIViewController {
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(logoImageView)
        
        animate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoImageView.center = view.center
    }
    
    private func animate() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
                            self.logoImageView.transform = CGAffineTransform(scaleX: 286, y: 286)
                        },
                       completion: { done in
            if done {
                UIView.animate(withDuration: 1,
                               animations: {
                                    self.logoImageView.alpha = 0.5
                                    self.logoImageView.transform = CGAffineTransform(scaleX: 83, y: 83)
                                },
                               completion: { done in
                    if done {
                        let playingNowViewController = PlayingNowCollectionViewController()
                        playingNowViewController.modalTransitionStyle = .crossDissolve
                        playingNowViewController.modalPresentationStyle = .fullScreen
                        self.present(playingNowViewController, animated: true)
                    }
                                })
            }
                        })
    }

}
