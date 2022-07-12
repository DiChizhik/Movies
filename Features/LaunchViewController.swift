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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                            self.presentViewController()
                                                        }
                                                    }
                                                })
                            }
                        })
    }
    
    private func presentViewController() {
        let tabBarController = UITabBarController()

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 16
        let playingNowCollectionViewController = PlayingNowCollectionViewController(collectionViewLayout: layout)
        let playingNowTabNavigationController = UINavigationController(rootViewController: playingNowCollectionViewController)
        playingNowTabNavigationController.tabBarItem.image = UIImage(named: "playingNowIcon")
        playingNowTabNavigationController.tabBarItem.title = "Playing now"

        let mostPopularViewController = MostPopularViewController()
        let mostPopularTabNavigationController = UINavigationController(rootViewController: mostPopularViewController)
        mostPopularTabNavigationController.tabBarItem.image = UIImage(named: "mostRecentIcon")
        mostPopularTabNavigationController.tabBarItem.title = "Most popular"
        
        let searchViewController = SearchViewController()
        let searchTabNavigationController = UINavigationController(rootViewController: searchViewController)
        searchTabNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        searchTabNavigationController.tabBarItem.title = "Search"
        
        setupTabBar()

        tabBarController.viewControllers = [
            playingNowTabNavigationController,
            mostPopularTabNavigationController,
            searchTabNavigationController
        ]
        
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
    
    private func setupTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "nonSelectedTab")!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : UIColor(named: "selectedTab")!], for: .selected)
        UITabBar.appearance().tintColor = UIColor(named: "selectedTab")
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "nonSelectedTab")
        UITabBar.appearance().barTintColor = UIColor(named: "backgroundColor")
    }

}
