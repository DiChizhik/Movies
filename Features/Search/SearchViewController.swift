//
//  SearchViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 11/07/2022.
//

import UIKit

final class SearchViewController: UIViewController {
    private let movieDataService: MovieDataServiceProtocol
    private let watchlistService: WatchlistServiceProtocol
    
    private var searchResults = [Movie]()
    
    private lazy var contentView: SearchView = {
        let view = SearchView()
        view.delegate = self
        view.tableViewDelegate = self
        view.tableViewDataSource = self
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
        super.loadView()
        
        self.view = contentView
        
        navigationItem.title = MovieTabBarItem.search.title + " for movies"
        navigationController?.navigationBar.barTintColor = .darkBlue01
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)]
        
        navigationItem.searchController = contentView.searchController
        contentView.searchController.searchBar.searchTextField.textColor = .whiteF5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.tableView.reloadData()
    }
}

// MARK: - WatchlistButtonDelegate
extension SearchViewController: WatchlistButtonDelegate {
    func watchlistTapped(_ view: WatchlistHandleable) {
        guard let cell = view as? UITableViewCell else { return }
        
        if let indexPath = contentView.tableView.indexPath(for: cell) {
            let movie = searchResults[indexPath.row]

            watchlistService.toggleStatus(for: movie) { [weak view] result in
                switch result {
                case .success(let updatedStatus):
                    view?.watchlistButton.updateWithStatus(updatedStatus, isShortVariant: false)
                case .failure:
                    break
                }
            }
        }
    }
}

//MARK: - SearchViewDelegate
extension SearchViewController: SearchViewDelegate {
    func startSearching(_ searchView: SearchView, for text: String) {
        movieDataService.searchMovies(matching: text) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let results):
                self.searchResults = results
            case .failure(let error):
                DispatchQueue.main.async {
                    ErrorViewController.handleError(error, presentingViewController: self)
                }
            }

            DispatchQueue.main.async {
                self.contentView.tableView.reloadData()
            }
        }
    }
}

//MARK: - MovieDetailViewDelegate
extension SearchViewController: MovieDetailViewDelegate {
    func didUpdateWatchlist(_ controller: UIViewController) {
        contentView.tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SearchTableViewCell.self, for: indexPath)
        cell.watchlistButtonDelegate = self
        
        let movie = searchResults[indexPath.row]

        watchlistService.getStatus(for: movie.id) { [weak cell] result in
            switch result {
            case .success(let status):
                cell?.configure(imageURL: movie.posterPath, title: movie.title, reviewsScore: movie.voteAverage, status: status)
            case .failure(_):
                cell?.configure(imageURL: movie.posterPath, title: movie.title, reviewsScore: movie.voteAverage, status: .notAdded)
            }
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovieID = searchResults[indexPath.row].id
        
        let detailViewController = MovieDetailViewController(selectedMovieID: selectedMovieID,
                                                             movieDataService: MovieDataService(),
                                                             watchlistService: WatchlistService())
        detailViewController.delegate = self
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        present(detailNavigationController, animated: true)
    }
}
