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
        
        let watchlistViewController = WatchlistViewController()
        let watchlistNavigationController = UINavigationController(rootViewController: watchlistViewController)
        watchlistNavigationController.tabBarItem.image = UIImage(named: "ticket")
        watchlistNavigationController.tabBarItem.title = "Watchlist"
        
        setupTabBar()

        tabBarController.viewControllers = [
            playingNowTabNavigationController,
            mostPopularTabNavigationController,
            watchlistNavigationController,
            searchTabNavigationController
        ]
        
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
    
    func setupTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightBlue61], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : UIColor.whiteF5], for: .selected)
        UITabBar.appearance().tintColor = UIColor.whiteF5
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightBlue61
        UITabBar.appearance().barTintColor = .darkBlue01
    }

}
