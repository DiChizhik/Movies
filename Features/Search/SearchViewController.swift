//
//  SearchViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 11/07/2022.
//

import UIKit

class SearchViewController: UIViewController {
    let movieDataService = MovieDataService()
    private var searchResults = [Movie]()
    
    private lazy var contentView: SearchView = {
        let view = SearchView()
        view.delegate = self
        view.tableViewDelegate = self
        view.tableViewDataSource = self
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view = contentView
        
        title = "Search Movies"
        navigationController?.navigationBar.barTintColor = .darkBlue01
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)]
        
        navigationItem.searchController = contentView.searchController
        contentView.searchController.searchBar.searchTextField.textColor = .whiteF5
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

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SearchTableViewCell.self, for: indexPath)
        
        let movie = searchResults[indexPath.row]
        cell.configure(imageURL: movie.posterPath, title: movie.title, reviewsScore: movie.voteAverage)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovieID = searchResults[indexPath.row].id
        
        let detailViewController = MovieDetailViewController(selectedMovieID: selectedMovieID)
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        present(detailNavigationController, animated: true)
    }
}
