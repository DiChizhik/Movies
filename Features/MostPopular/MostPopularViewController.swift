//
//  MostPopularCollectionViewControllerswift
//  Movies
//
//  Created by Diana Chizhik on 25/05/2022.
//

import UIKit
import Kingfisher

final class MostPopularViewController: UIViewController {
    private enum Fading: Int {
        case fadeIn = 1
        case fadeOut = 0
    }
    
    private let movieDataService: MovieDataServiceProtocol
    private let watchlistService: WatchlistServiceProtocol
    
    private var movies = [Movie]()
    private var itemInViewIndex: Int = 0
    
    private lazy var contentView: MostPopularView = {
        let view = MostPopularView()
        view.collectionViewDelegate = self
        view.collectionViewDataSource = self
        view.delegate = self
        view.watchlistButtonDelegate = self
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
        
        title = MovieTabBarItem.mostPopular.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 20, weight: .heavy)
        ]
        navigationController?.navigationBar.backgroundColor = .darkBlue01
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovieData()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureWithData(index: itemInViewIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        configureForItemInView()
    }
}
 
// MARK: - Public functions
extension MostPopularViewController: MostPopularViewDelegate, WatchlistButtonDelegate {
    func watchlistTapped(_ view: WatchlistHandleable) {
        guard let movie = movies[safe: itemInViewIndex] else { return }

        watchlistService.toggleStatus(for: movie) { [weak view] result in
            switch result {
            case .success(let updatedStatus):
                view?.watchlistButton.updateWithStatus(updatedStatus, isShortVariant: false)
            case .failure(_):
                break
            }
        }
    }
    
    func seeMoreTapped(_ mostPopularView: MostPopularView) {
        guard let selectedMovie = movies[safe: itemInViewIndex] else { return }
        
        let detailViewController = MovieDetailViewController(selectedMovieID: selectedMovie.id,
                                                             movieDataService: MovieDataService(),
                                                             watchlistService: WatchlistService())
        detailViewController.delegate = self
        let detailNavigationController = UINavigationController(rootViewController: detailViewController)
        present(detailNavigationController, animated: true)
    }
}

// MARK: - Private functions
private extension MostPopularViewController {
    func loadMovieData() {
        movieDataService.getMostPopularMoviesList { [weak self] result in
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
                guard self.movies.count > self.itemInViewIndex else { return }
                
                self.contentView.collectionView.reloadData()
                self.configureWithData(index: self.itemInViewIndex)
                self.fade(.fadeIn)
            }
        }
    }
    
    private func configureWithData(index: Int) {
        let movie = movies[safe: index]
        
        if let movie = movie {
            let movieName = movie.title
            let reviewsScore = movie.voteAverage
            let movieDescription = movie.overview
            let movieID = movie.id
            
            watchlistService.getStatus(for: movieID) { [weak contentView] result in
                switch result {
                case .success(let status):
                    contentView?.configureWith(name: movieName, score: reviewsScore, description: movieDescription, status: status)
                case .failure(_):
                    contentView?.configureWith(name: movieName, score: reviewsScore, description: movieDescription, status: .notAdded)
                }
            }
        }
    }
    
    private func fade(_ type: MostPopularViewController.Fading) {
        let alpha = CGFloat(type.rawValue)
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [],
                       animations: {
            self.contentView.changeAlpha(to: alpha)
                    }, completion: nil)
    }
}

//MARK: - MovieDetailViewController
extension MostPopularViewController: MovieDetailViewDelegate {
    func didUpdateWatchlist(_ controller: UIViewController) {
        configureWithData(index: itemInViewIndex)
    }
}

// MARK: - UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegate
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

// MARK: - UICollectionViewDelegateFlowLayout
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


