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
        navigationController?.navigationBar.barTintColor = .darkBlue01
    }
   
//    I've replaced viewDidLoad with viewDidAppear to ensure watchlist is up-to-date with the changes I make in other tabs. I guess I'll have to do the same for other screen so that watchlistButton appearance is up-to-date too.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let watchlistItems = watchlistService.getWatchlistItems() else { return }
        loadMovieData(for: watchlistItems)
    }
}

// MARK: - Private functions
private extension WatchlistViewController {
    func loadMovieData(for items: [WatchlistItem]) {
        movies.removeAll()
        
        for item in items {
            movieDataService.getMovieDetails(movieId: item.id) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let details):
                    self.movies.append(details)
                    DispatchQueue.main.async {
                        self.contentView.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        ErrorViewController.handleError(error, presentingViewController: self)
                    }
                }
            }
        }
    }
}

// MARK: - WatchlistButtonDelegate
extension WatchlistViewController: WatchlistButtonDelegate {
//    It might make sense to add slightly different logic to this function. Like immediately deleting the row where the button was tapped.
    func watchlistTapped(_ view: WatchlistHandleable) {
        guard let cell = view as? UITableViewCell else { return }
        
        if let indexPath = contentView.tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let watchlistItem = WatchlistItem(id: movie.id, saveDate: Date.now)
            
            let updatedStatus = watchlistService.toggleStatus(for: watchlistItem)
            view.watchlistButton.updateWithStatus(updatedStatus, isShortVariant: false)
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
        let cell = tableView.dequeue(WatchlistTableViewCell.self, for: indexPath)
        cell.watchlistButtonDelegate = self

        let item = movies[indexPath.row]
        let status = watchlistService.getStatus(for: item.id)
        cell.configure(imageURL: item.posterPath, title: item.title, reviewsScore: item.voteAverage, status: status)
        return cell
    }
}
