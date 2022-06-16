//
//  PlayingNowCollectionViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 25/05/2022.
//

import UIKit

class PlayingNowCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var movies = [Movie]()
    let movieDataService = MovieDataService()
    
    var selectedItemId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        

        navigationItem.title = "Playing now"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 24, weight: .heavy)]
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "backgroundColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "backgroundColor")
        
        collectionView.register(PlayingNowCollectionViewCell.self, forCellWithReuseIdentifier: PlayingNowCollectionViewCell.reuseIdentifier)

        movieDataService.getPlayingNowMoviesList { [weak self] (moviesList: [Movie]?) in
                if let moviesList = moviesList {
                    self?.movies = moviesList
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayingNowCollectionViewCell.reuseIdentifier, for: indexPath) as? PlayingNowCollectionViewCell else { fatalError() }
        
        let movieName = movies[indexPath.item].title
        let reviewsScore = "\(movies[indexPath.item].voteAverage)%"
        let path = movies[indexPath.item].posterPath
        if let url = movieDataService.getMoviePosterURL(posterPath: path) {
            cell.configure(imageURL: url, name: movieName, duration: "0h0", reviewsScore: reviewsScore)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width * 0.41
        let height = width * 1.6
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 18)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = movies[indexPath.item].id
        
        let detailViewController = DetailViewController()
        let detailViewNavigationController = UINavigationController(rootViewController: detailViewController)
        detailViewController.selectedMovieId = id
        present(detailViewNavigationController, animated: true)
    }
}

