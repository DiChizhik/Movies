//
//  MostPopularCollectionViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 25/05/2022.
//

import UIKit
import Kingfisher

class MostPopularViewController: UIViewController, UICollectionViewDelegate {
    var movies = [Movie]()
    let movieDataService = MovieDataService()
    var itemInViewIndex: Int = 0
    
    private lazy var contentView: MostPopularView = {
        let view = MostPopularView()
        view.collectionView.dataSource = self
        view.collectionView.delegate = self
        view.seeMoreButton.addTarget(self, action: #selector(seeMoreTapped), for: .touchUpInside)
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
        
//        I did it in an attemt to make loadMovieData method reusable in willDisplayCell method. I'm not sure it's right, though.
        DispatchQueue.main.async {
            self.contentView.collectionView.scrollToItem(at: IndexPath(item: self.itemInViewIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            self.configureWithData(index: self.itemInViewIndex)
            self.fadeIn()
        }
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
    
    @objc func seeMoreTapped(_ sender: UIButton) {
        let selectedMovieId = movies[itemInViewIndex].id
        let detailViewController = MovieDetailViewController(selectedMovieID: selectedMovieId)
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        present(detailNavigationController, animated: true)
    }
}

// I've put all scroll-related methods here.
extension MostPopularViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        fadeOut()
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
        
        fadeIn()
    }
    
    private func fadeIn() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
            self.contentView.name.alpha = 1
            self.contentView.reviewsScore.alpha = 1
            self.contentView.reviewsScoreIndicator.alpha = 1
            self.contentView.movieDescription.alpha = 1
            self.contentView.seeMoreButton.alpha = 1
                    }, completion: nil)
    }
    
    private func fadeOut() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
            self.contentView.name.alpha = 0
            self.contentView.reviewsScore.alpha = 0
            self.contentView.reviewsScoreIndicator.alpha = 0
            self.contentView.movieDescription.alpha = 0
            self.contentView.seeMoreButton.alpha = 0
            },
                       completion: nil)
    }
    
}
    
extension MostPopularViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostPopularCollectionViewCell.reuseIndentifier, for: indexPath) as? MostPopularCollectionViewCell else { fatalError() }
            
        let path = movies[indexPath.item].posterPath
        cell.configure(imageURL: path)
        
        return cell
    }
}

// Why is conformance to UICollectionViewDelegate here redundant?
extension MostPopularViewController {
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


