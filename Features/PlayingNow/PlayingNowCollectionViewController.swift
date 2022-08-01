//
//  PlayingNowCollectionViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 25/05/2022.
//

import UIKit

class PlayingNowCollectionViewController: UICollectionViewController {
    private var movies = [Movie]()
    private let movieDataService = MovieDataService()
    private let watchlistService = WatchlistService()
    
    var selectedItemId: Int?
    
    override func loadView() {
        super.loadView()
        
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(PlayingNowCollectionViewCell.self)

        loadMovieData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Private functions
private extension PlayingNowCollectionViewController {
    func setupUI() {
        collectionView.backgroundColor = .darkBlue01
        
        navigationItem.title = "Playing Now"

        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)]
        navigationController?.navigationBar.barTintColor = .darkBlue01
    }
    
    func loadMovieData() {
        movieDataService.getPlayingNowMoviesList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let moviesList):
                self.movies.append(contentsOf: moviesList)
            case .failure(let error):
                DispatchQueue.main.async {
                    ErrorViewController.handleError(error, presentingViewController: self)
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - WatchlistButtonDelegate
extension PlayingNowCollectionViewController: WatchlistButtonDelegate {
    func watchlistTapped(_ view: WatchlistHandleable) {
        guard let cell = view as? UICollectionViewCell else { return }
        
        if let indexPath = collectionView.indexPath(for: cell) {
            let movie = movies[indexPath.item]
            let watchlistItem = WatchlistItem(id: movie.id, saveDate: Date.now)
            
            let updatedStatus = watchlistService.toggleStatus(for: watchlistItem)
            view.watchlistButton.updateWithStatus(updatedStatus, isShortVariant: true)
            
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PlayingNowCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PlayingNowCollectionViewCell.self, for: indexPath)
        cell.watchlistButtonDelegate = self
        
        let movie = movies[indexPath.item]
        let movieName = movie.title
        let reviewsScore = movie.voteAverage
        let path = movie.posterPath
        let movieID = movie.id
        
        let status = watchlistService.getStatus(for: movieID)
        
        cell.configure(imageURL: path, name: movieName, reviewsScore: reviewsScore, status: status)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PlayingNowCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovieID = movies[indexPath.item].id
        let detailViewController = MovieDetailViewController(selectedMovieID: selectedMovieID)
        
        let detailViewNavigationController = UINavigationController(rootViewController: detailViewController)
        present(detailViewNavigationController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let movieInViewIndex = indexPath.item
        let lastMovieIndex = movies.count - 1
        if movieInViewIndex == lastMovieIndex {
            loadMovieData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PlayingNowCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width * 0.42
        let height = width * 1.75
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 27, left: 16, bottom: 24, right: 18)
    }
}

