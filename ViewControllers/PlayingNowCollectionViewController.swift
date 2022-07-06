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
    
    private func setupUI() {
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        
        navigationItem.title = "Playing Now"
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)]
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "backgroundColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "backgroundColor")
    }
    
    private func loadMovieData() {
        movieDataService.getPlayingNowMoviesList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let moviesList):
                self.movies.append(contentsOf: moviesList)
            case .failure(_):
                break
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension PlayingNowCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(PlayingNowCollectionViewCell.self, for: indexPath)
        
        let movie = movies[indexPath.item]
        let movieName = movie.title
        let reviewsScore = movie.voteAverage
        let popularity = movie.popularity
        let path = movie.posterPath
        cell.configure(imageURL: path, name: movieName, reviewsScore: reviewsScore, popularity: popularity)
        
        return cell
    }
}

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

