//
//  WatchListViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 20.07.22.
//

import UIKit

final class WatchlistViewController: UIViewController {
    private let movieDataService: MovieDataServiceProtocol
    private let watchlistService: WatchlistServiceProtocol
    
    private var movies = [WatchlistItem]()
    
    private lazy var contentView: WatchlistView = {
        let view = WatchlistView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    init(movieDataService: MovieDataServiceProtocol,
         watchlistService: WatchlistServiceProtocol) {
        self.movieDataService = movieDataService
        self.watchlistService = watchlistService
        
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
//        movies = watchlistService.getWatchlist()
        watchlistService.getWatchlist { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let savedWatchlist):
                self.movies = savedWatchlist
            case .failure(_):
                self.movies = [WatchlistItem]()
            }
        }
        
        contentView.tableView.reloadData()
    }
}

// MARK: - WatchlistButtonDelegate
extension WatchlistViewController: WatchlistButtonDelegate {
    func watchlistTapped(_ view: WatchlistHandleable) {
        guard let cell = view as? UITableViewCell else { return }
        guard let indexPath = contentView.tableView.indexPath(for: cell) else { return }
        
        if let movie = movies[safe: indexPath.row] {
            
//          let _ = watchlistService.toggleStatus(for: movie)
            watchlistService.toggleStatus(for: movie) { _ in return }
            
            loadWatchlist()
        }
    }
}

//MARK: - MovieDetailViewDelegate
extension WatchlistViewController: MovieDetailViewDelegate {
    func didUpdateWatchlist(_ controller: UIViewController) {
        loadWatchlist()
    }
}

// MARK: - UITableViewDelegate
extension WatchlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = movies[safe: indexPath.row] else { return }
        
        let detailViewController = MovieDetailViewController(selectedMovieID: Int(movie.id),
                                                             movieDataService: MovieDataService(),
                                                             watchlistService: WatchlistService())
        detailViewController.delegate = self
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

//        if let status = try? watchlistService.getStatus(for: Int(item.id)) {
//            cell.configure(imageURL: item.posterPath, title: item.title, reviewsScore: (Int(item.voteAverage)), status: status)
//        } else {
//            ErrorViewController.handleError(WatchlistServiceError.failedToFetchFromPersistentStore, presentingViewController: self)
//        }
        
        watchlistService.getStatus(for: item.id) { [weak cell] result in
            switch result {
            case .success(let status):
                cell?.configure(imageURL: item.posterPath, title: item.title, reviewsScore: (Int(item.voteAverage)), status: status)
            case .failure(_):
                cell?.configure(imageURL: item.posterPath, title: item.title, reviewsScore: (Int(item.voteAverage)), status: .added)
            }
        }
        
        return cell
    }
}
