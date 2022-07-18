//
//  MostPopularCollectionViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 25/05/2022.
//

import UIKit
import Kingfisher

class MostPopularViewController: UIViewController, MostPopularViewDelegate {
    private enum Fading: Int {
        case fadeIn = 1
        case fadeOut = 0
    }
    
    var movies = [Movie]()
    let movieDataService = MovieDataService()
    var itemInViewIndex: Int = 0
    
    private lazy var contentView: MostPopularView = {
        let view = MostPopularView()
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        view.delegate = self
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view = contentView
        
        title = "Most Popular"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)]
        navigationController?.navigationBar.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovieData()
        
//        The app crashed if there were no movies(Error: Failed to load from server), so I added this check to prevent the crash.
        DispatchQueue.main.async {
            guard !self.movies.isEmpty else { return }
            
            self.contentView.collectionView.scrollToItem(at: IndexPath(item: self.itemInViewIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            self.configureWithData(index: self.itemInViewIndex)
            self.fade(.fadeIn)
        }
    }

    private func loadMovieData() {
        movieDataService.getPlayingNowMoviesList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let moviesList):
                self.movies.append(contentsOf: moviesList)
            case .failure(let error):
                DispatchQueue.main.async {
                    let vc = ErrorViewController(error: error)
                    vc.modalPresentationStyle = .popover
                    self.present(vc, animated: true)
                }
            }
            
            DispatchQueue.main.async {
                self.contentView.collectionView.reloadData()
            }
        }
    }
    
    private func configureWithData(index: Int) {
        let movie = movies[index]
        
        let movieName = movie.title
        let reviewsScore = "\(movie.voteAverage)%"
        let movieDescription = movie.overview
        
        contentView.name.text = movieName
        contentView.reviewsScore.text = reviewsScore
        contentView.movieDescription.text = movieDescription
        
        updateReviewScoreIndicator(reviewsScore: reviewsScore)
    }
    
    private func updateReviewScoreIndicator(reviewsScore: String) {
        let score = reviewsScore.components(separatedBy: "%")
        if let scoreInt = Int(score[0]) {
            if scoreInt > 50 {
                contentView.reviewsScoreIndicator.image = UIImage(named: "highReviewsScore")
            } else {
                contentView.reviewsScoreIndicator.image = UIImage(named: "lowReviewsScore")
            }
        }
    }
    
    func seeMoreTapped() {
        let selectedMovieId = movies[itemInViewIndex].id
        
        let detailViewController = MovieDetailViewController(selectedMovieID: selectedMovieId)
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        present(detailNavigationController, animated: true)
    }
    
    private func fade(_ type: Fading) {
        let type = CGFloat(type.rawValue)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
            self.contentView.name.alpha = type
            self.contentView.reviewsScore.alpha = type
            self.contentView.reviewsScoreIndicator.alpha = type
            self.contentView.movieDescription.alpha = type
            self.contentView.seeMoreButton.alpha = type
                    }, completion: nil)
    }
}
    
extension MostPopularViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(MostPopularCollectionViewCell.self, for: indexPath)
            
        let path = movies[indexPath.item].posterPath
        cell.configure(imageURL: path)
        
        return cell
    }
}

extension MostPopularViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        fade(.fadeOut)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate == false else { return }
        
        configureForItemInView()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       configureForItemInView()
    }
    
    private func configureForItemInView() {
        let pageFloat = (contentView.collectionView.contentOffset.x / ((contentView.collectionView.bounds.size.height * 0.7) + 32))
        let pageInt = Int(round(pageFloat))
        itemInViewIndex = pageInt
        
        contentView.collectionView.scrollToItem(at: IndexPath(item: pageInt, section: 0), at: .centeredHorizontally, animated: true)
        configureWithData(index: pageInt)
        
        fade(.fadeIn)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let movieInViewIndex = indexPath.item
        let lastMovieIndex = movies.count - 1
        if movieInViewIndex == lastMovieIndex {
            loadMovieData()
        }
    }
}

extension MostPopularViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = height * 0.7
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let itemWidth = collectionView.bounds.size.height * 0.7
        let leftInset = (collectionView.bounds.size.width - itemWidth) / 2
        
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 16)
    }
}


