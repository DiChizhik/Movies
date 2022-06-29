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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MostPopularCollectionViewCell.self, forCellWithReuseIdentifier: MostPopularCollectionViewCell.reuseIndentifier)
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        return collectionView
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 32
        layout.minimumLineSpacing = 30
        return layout
    }()
    
    private var name: UILabel = {
       let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Film name"
        name.textAlignment = .center
        name.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        name.textColor = UIColor(named: "titleColor")
        name.alpha = 0
        return name
    }()
    
    private var reviewsScore: UILabel = {
       let reviewsScore = UILabel()
        reviewsScore.translatesAutoresizingMaskIntoConstraints = false
        reviewsScore.font = UIFont.systemFont(ofSize: 15)
        reviewsScore.text = "00%"
        reviewsScore.textColor = UIColor(named: "titleColor")
        reviewsScore.alpha = 0
        return reviewsScore
    }()
    
    private lazy var reviewsScoreIndicator: UIImageView = {
        let reviewsScoreIndicator = UIImageView()
        reviewsScoreIndicator.translatesAutoresizingMaskIntoConstraints = false
        reviewsScoreIndicator.heightAnchor.constraint(equalToConstant: 15).isActive = true
        reviewsScoreIndicator.widthAnchor.constraint(equalTo: reviewsScoreIndicator.heightAnchor, multiplier: 1.13).isActive = true
        reviewsScoreIndicator.alpha = 0
        return reviewsScoreIndicator
    }()
    
    private lazy var movieDescription: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 3
        description.font = UIFont.systemFont(ofSize: 15)
        description.textColor = UIColor(named: "descriptionColor")
        description.textAlignment = .center
        description.text = """
                        a very
                        thought-provocing
                        black-humoured
                        romcom
                        """
        description.alpha = 0
        return description
    }()
    
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(seeMoreTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See more", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.tintColor = UIColor(named: "titleColor")
        button.alpha = 0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        movieDataService.getMostPopularMoviesList { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let moviesList):
                self.movies = moviesList
            case .failure(_):
                break
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.itemInViewIndex = Int(round(Double((self.movies.count) / 2)))
                self.collectionView.scrollToItem(at: IndexPath(item: self.itemInViewIndex, section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                self.configureWithData(index: self.itemInViewIndex)
                self.fadeIn()
                }
        }
    }
    
    private func setupUI() {
        title = "Most Popular"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 20, weight: .heavy)]
        navigationController?.navigationBar.backgroundColor = UIColor(named: "backgroundColor")
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 27)
        ])
        
        view.addSubview(name)
        view.addSubview(reviewsScore)
        view.addSubview(reviewsScoreIndicator)
        view.addSubview(movieDescription)
        view.addSubview(seeMoreButton)
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            name.widthAnchor.constraint(equalToConstant: 195),
            name.heightAnchor.constraint(equalToConstant: 24),
            
            reviewsScore.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 6),
            reviewsScore.centerXAnchor.constraint(equalTo: name.centerXAnchor, constant: 12),
            
            reviewsScoreIndicator.centerYAnchor.constraint(equalTo: reviewsScore.centerYAnchor),
            reviewsScoreIndicator.trailingAnchor.constraint(equalTo: reviewsScore.leadingAnchor, constant: -8),
            
            movieDescription.topAnchor.constraint(equalTo: reviewsScore.bottomAnchor, constant: 24),
            movieDescription.centerXAnchor.constraint(equalTo: name.centerXAnchor),
            movieDescription.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            movieDescription.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            seeMoreButton.topAnchor.constraint(equalTo: movieDescription.bottomAnchor, constant: 8),
            seeMoreButton.centerXAnchor.constraint(equalTo: name.centerXAnchor)
        ])
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        fadeOut()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate == false else { return }
        
        let pageFloat = (collectionView.contentOffset.x / ((collectionView.bounds.size.height * 0.7) + 32))
            let pageInt = Int(round(pageFloat))
            itemInViewIndex = pageInt
            collectionView.scrollToItem(at: IndexPath(item: pageInt, section: 0), at: .centeredHorizontally, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageFloat = (collectionView.contentOffset.x / ((collectionView.bounds.size.height * 0.7) + 32))
        let pageInt = Int(round(pageFloat))
        itemInViewIndex = pageInt
        collectionView.scrollToItem(at: IndexPath(item: pageInt, section: 0), at: .centeredHorizontally, animated: true)
        
        configureWithData(index: pageInt)
        
        fadeIn()
    }

    private func configureWithData(index: Int) {
        let movie = movies[index]
        
        let movieName = movie.title
        let reviewsScore = "\(movie.voteAverage)%"
        let movieDescription = movie.overview
        
        name.text = movieName
        self.reviewsScore.text = reviewsScore
        self.movieDescription.text = movieDescription
        
        updateReviewScoreIndicator(reviewsScore: reviewsScore)
    }
    
    func updateReviewScoreIndicator(reviewsScore: String) {
        let score = reviewsScore.components(separatedBy: "%")
        if let scoreInt = Int(score[0]) {
            if scoreInt > 50 {
                reviewsScoreIndicator.image = UIImage(named: "highReviewsScore")
            } else {
                reviewsScoreIndicator.image = UIImage(named: "lowReviewsScore")
            }
        }
    }
    
    private func fadeIn() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
            self.name.alpha = 1
            self.reviewsScore.alpha = 1
            self.reviewsScoreIndicator.alpha = 1
            self.movieDescription.alpha = 1
            self.seeMoreButton.alpha = 1
                    }, completion: nil)
    }
    
    private func fadeOut() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
            self.name.alpha = 0
            self.reviewsScore.alpha = 0
            self.reviewsScoreIndicator.alpha = 0
            self.movieDescription.alpha = 0
            self.seeMoreButton.alpha = 0
            },
                       completion: nil)
    }
    
    @objc func seeMoreTapped(_ sender: UIButton) {
        let detailViewController = DetailViewController(selectedMovieID: movies[itemInViewIndex].id)
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        present(detailNavigationController, animated: true)
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

extension MostPopularViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = height * 0.7
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}


