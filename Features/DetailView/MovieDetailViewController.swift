//
//  DetailViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 07/06/2022.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    private var selectedMovieID: Int
    private let movieDataService = MovieDataService()
    private let watchlistService = WatchlistService()
    
    private var movieDetails: MovieDetails?
    private var languageAndGenreData = [CollectionViewSection]()
    
    private lazy var contentView: StackMovieDetailView = {
        let view = StackMovieDetailView()
        view.collectionView.dataSource = self
        view.watchlistButtonDelegate = self
        return view
    }()

    init(selectedMovieID: Int) {
        self.selectedMovieID = selectedMovieID
        
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = contentView
        
        let exitButton = UIButton.systemButton(with: UIImage(systemName: "xmark")!, target: self, action: #selector(dismissView))
        exitButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)

        navigationController?.navigationBar.barTintColor = .darkBlue01
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMovieData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        contentView.collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - Private functions
private extension MovieDetailViewController {
    func loadMovieData() {
        movieDataService.getMovieDetails(movieId: selectedMovieID) { [weak self] result in
            guard let self = self else {return}
                
            switch result {
            case .success(let details):
                self.movieDetails = details
                DispatchQueue.main.async {
                    self.configureWithData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    ErrorViewController.handleError(error, presentingViewController: self)
                }
            }
        }
    }
    
    func configureWithData() {
        guard let movieDetails = movieDetails else { return }

        contentView.titleLabel.text = movieDetails.title
        
        if let path = movieDetails.posterPath {
            contentView.imageView.kf.setImage(with: path)
        }
        
        let status = watchlistService.getStatus(for: selectedMovieID)
        contentView.watchlistButton.updateWithStatus(status, isShortVariant: false)
        
        contentView.reviewScoreStackView.setValue(movieDetails.voteAverage)
        contentView.releaseDateLabel.text = movieDetails.releaseDate
        contentView.durationLabel.text = movieDetails.runtime
        contentView.movieDescriptionLabel.text = movieDetails.overview
       
        let languages = movieDetails.spokenLanguages.map{ CollectionViewItem(title: $0.englishName) }
        let genres = movieDetails.genres.map{ CollectionViewItem(title: $0.name) }
        
        let languagesSection = CollectionViewSection(identifier: CollectionViewSectionIdentifier.languages, items: languages)
        let genreSection = CollectionViewSection(identifier: .genres, items: genres)
        languageAndGenreData = [languagesSection, genreSection]
        contentView.collectionView.reloadData()
    }
    
    @objc func dismissView(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - WatchlistButtonDelegate
extension MovieDetailViewController: WatchlistButtonDelegate {
    func watchlistTapped(_ view: WatchlistHandleable) {
        guard let movieDetails = movieDetails else { return }
        
        let watchlistItem = WatchlistItem(id: selectedMovieID,
                                          saveDate: Date.now,
                                          title: movieDetails.title,
                                          voteAverage: movieDetails.voteAverage,
                                          posterPath: movieDetails.posterPath)

        let updatedStatus = watchlistService.toggleStatus(for: watchlistItem)
        contentView.watchlistButton.updateWithStatus(updatedStatus, isShortVariant: false)
    }   
}

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return languageAndGenreData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languageAndGenreData[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(DetailCollectionViewCell.self, for: indexPath)
        let item = languageAndGenreData[indexPath.section].items[indexPath.item].title.lowercased().capitalizingFirstLetter()
        
        switch languageAndGenreData[indexPath.section].identifier {
        case .languages:
            cell.configure(title: item, backgroundColor: .blue2A, borderColor: .lightBlue61)
        case .genres:
            cell.configure(title: item, backgroundColor: .lightBlue61, borderColor: .lightBlue61)
        }
        
        return cell
    }
}

private extension MovieDetailViewController {
    enum CollectionViewSectionIdentifier {
        case languages, genres
    }
    
    struct CollectionViewItem {
        let title: String
    }
    
    struct CollectionViewSection {
        let identifier: CollectionViewSectionIdentifier
        let items: [CollectionViewItem]
    }
}
