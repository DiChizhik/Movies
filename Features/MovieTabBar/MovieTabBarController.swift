//
//  MovieTabBarController.swift
//  Movies
//
//  Created by Diana Chizhik on 3.08.22.
//

import UIKit

class MovieTabBarController: UITabBarController {
    var tabItems: [MovieTabBarItem]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        tabItems = [MovieTabBarItem]()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(items: [MovieTabBarItem]) {
        tabItems = items
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMovieTabBar()
    }
    
    private func setupMovieTabBar() {
        var controllers = [UIViewController]()
        
        for item in tabItems {
            let vc = item.rootViewController
            let navController = UINavigationController(rootViewController: vc)
            navController.tabBarItem.title = item.title
            navController.tabBarItem.image = item.image
            
            controllers.append(navController)
        }
        
        viewControllers = controllers
        assert(viewControllers != nil)
        
        setupMovieTabBarAppearance()
    }
    
    private func setupMovieTabBarAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.lightBlue61], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor : UIColor.whiteF5], for: .selected)
        UITabBar.appearance().tintColor = UIColor.whiteF5
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightBlue61
        UITabBar.appearance().barTintColor = .darkBlue01
    }

}
