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
    var movies = [MovieDetails]()
    
    private lazy var contentView: WatchlistView = {
        let view = WatchlistView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    override func loadView() {
        self.view = contentView
        
        title = "Watchlist"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy)
        ]
        navigationController?.navigationBar.barTintColor = .backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let watchlistItems = watchlistService.getWatchlistItems() else { return }
        
        for item in watchlistItems {
            movieDataService.getMovieDetails(movieId: item.id) { [weak self] result in
                switch result {
                case .success(let details):
                    self?.movies.append(details)
                    DispatchQueue.main.async { [weak self] in
                        self?.contentView.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension WatchlistViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension WatchlistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(WatchlisttableViewCell.self, for: indexPath)

        let item = movies[indexPath.row]
        cell.configure(imageURL: item.posterPath, title: item.title, reviewsScore: item.voteAverage)
        return cell
    }
}
