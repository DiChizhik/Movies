//
//  WatchListViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 20.07.22.
//

import UIKit

class WatchlistViewController: UIViewController {
    let watchlistService = WatchlistService()
    let movieDataService = MovieDataService()
    var movies = [WatchlistItem]()
    
    private lazy var contentView: WatchlistView = {
        let view = WatchlistView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    override func loadView() {
        self.view = contentView
        
        title = MovieTabBarItem.watchlist.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy)
        ]
        navigationController?.navigationBar.barTintColor = .darkBlue01
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadWatchlist()
    }
}

// MARK: - Private functions
private extension WatchlistViewController {
    func loadWatchlist() {
        movies.removeAll()
        movies = watchlistService.getWatchlistItems()
        
        contentView.tableView.reloadData()
    }
}

// MARK: - WatchlistButtonDelegate
extension WatchlistViewController: WatchlistButtonDelegate {
    func watchlistTapped(_ view: WatchlistHandleable) {
        guard let cell = view as? UITableViewCell else { return }
        guard let indexPath = contentView.tableView.indexPath(for: cell) else { return }
        
        if let movie = movies[safe: indexPath.row] {
            let watchlistItem = WatchlistItem(id: movie.id,
                                              saveDate: Date.now,
                                              title: movie.title,
                                              voteAverage: movie.voteAverage,
                                              posterPath: movie.posterPath)
            let _ = watchlistService.toggleStatus(for: watchlistItem)
            
            loadWatchlist()
        }
    }
}

// MARK: - UITableViewDelegate
extension WatchlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movies[safe: indexPath.row] else { return }
        
        let detailViewController = MovieDetailViewController(selectedMovieID: movie.id)
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        present(detailNavigationController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension WatchlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(WatchlistTableViewCell.self, for: indexPath)
        cell.watchlistButtonDelegate = self

        let item = movies[indexPath.row]
        let status = watchlistService.getStatus(for: item.id)
        cell.configure(imageURL: item.posterPath, title: item.title, reviewsScore: item.voteAverage, status: status)
        return cell
    }
}
