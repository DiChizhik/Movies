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
    private var isSearching = false
    
    private lazy var searchController: UISearchController = {
       let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.automaticallyShowsCancelButton = true
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Type movie name"
        search.searchBar.tintColor = UIColor(named: "titleColor")
//        This option doesn't work from here but works OK from loadView()
//        search.searchBar.searchTextField.textColor = UIColor(named: "titleColor")!
        
//        This option works but looks bulky and changes the size of the textField
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "titleColor")]
        return search
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        tableView.register(SearchTableViewCell.self)
        tableView.rowHeight = 124
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        title = "Search Movies"
        navigationController?.navigationBar.barTintColor = UIColor(named: "backgroundColor")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)]
        
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.textColor = UIColor(named: "titleColor")!
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(makeRequest), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func makeRequest() {
        isSearching = true
        updateSearchResults(for: searchController)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SearchTableViewCell.self, for: indexPath)
        
        let movie = searchResults[indexPath.row]
        cell.configure(imageURL: movie.posterPath, title: movie.title, reviewsScore: movie.voteAverage, popularity: movie.popularity)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovieID = searchResults[indexPath.row].id
        
        let detailViewController = MovieDetailViewController(selectedMovieID: selectedMovieID)
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        present(detailNavigationController, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard isSearching else { return }
        guard let text = searchController.searchBar.text else { return }
        
        movieDataService.searchMovies(matching: text) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let results):
                self.searchResults = results
            case .failure(_):
                break
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        isSearching = false
        
    }
}
