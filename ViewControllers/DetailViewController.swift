//
//  DetailViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 07/06/2022.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    private let selectedMovieID: Int
    private let movieDataService = MovieDataService()
    
    private var movieDetails: MovieDetails?
    private var languageAndGenreData = [CollectionViewSection]()
    
    // StackMovieDetailView and ConstraintMovieDetailView are basically the same,
    // they are only built internally differently. One using stacks the other using plain constraints.
    // Feel free to choose which one you prefer. Other one would look like:
    /// ```
    /// private lazy var contentView: ConstraintMovieDetailView = {
    ///     let view = ConstraintMovieDetailView()
    ///     view.collectionView.dataSource = self
    ///     return view
    /// }()
    private lazy var contentView: StackMovieDetailView = {
        let view = StackMovieDetailView()
        view.collectionView.dataSource = self
        return view
    }()
    
    // Since it doesn't make sense to load a movie detail screen without a movie selected we pass it on init :)
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
        
        // I'm just moving the view configuration to a separate class so we can fully follow MVC.
        // Ideally in the MVC architecture we separate in 3 components:
        // M (Model)
        //      Where your data resides. This will be persistance (database), API fetching, parsing objects, etc.
        //      In your case it's already separated in the MovieService class
        //
        // V (View)
        //      This is your UI. There is no code to handle user interaction or load content. Simply configure UI elements and style
        //      Will be our StackMovieDetailView or ConstraintMovieDetailView, depending on which one you choose
        //
        // C (Controller)
        //      This will mediate interactions between View and Model. Handles user interactions, loads data from model, etc.
        //      We already have this in the project, it's the DetailViewController itself
        //
        // NOTE: If you were using storyboards then the storyboard would be your "View", and the ViewController class the "Controller" part.
        // Since we are not using storyboards it's a good practice to take the "View" part from the "Controller" class to make it more readable.
        self.view = contentView
        
        let exitButton = UIButton.systemButton(with: UIImage(systemName: "xmark")!, target: self, action: #selector(dismissView))
        exitButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovieDetails()
    }
    
    @objc func dismissView(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        contentView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func fetchMovieDetails() {
        movieDataService.getMovieDetails(movieId: selectedMovieID) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let details):
                self.movieDetails = details
                DispatchQueue.main.async {
                    self.updateViewData()
                }
                
            case .failure(let error):
//                Here I wanted to display an alert controller with the info about the error. Not sure if error.localizedDescription will hold anything though.
                switch error {
                case .errorOccurred:
                    let ac = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    DispatchQueue.main.async {
                        self.present(ac, animated: true)
                    }
                default:
                    break
                }
            }
        }
    }
    
    private func updateViewData() {
        guard let movieDetails = movieDetails else { return }

        contentView.titleLabel.text = movieDetails.title

        if let path = movieDetails.posterPath {
            contentView.imageView.kf.setImage(with: path)
        }
        
        contentView.releaseDateLabel.text = movieDetails.releaseDate
        contentView.durationLabel.text = movieDetails.runtime
        contentView.movieDescriptionLabel.text = movieDetails.overview
        
        // I've moved the code from "makeViewData" to here
        let languages = movieDetails.spokenLanguages
            .map { CollectionViewItem(title: $0.englishName) }
        
        let genres = movieDetails.genres
            .map { CollectionViewItem(title: $0.name) }
        
        let languagesSection = CollectionViewSection(identifier: CollectionViewSectionIdentifier.languages, items: languages)
        let genreSection = CollectionViewSection(identifier: .genres, items: genres)
        languageAndGenreData = [languagesSection, genreSection]
        contentView.collectionView.reloadData()
    }
}

// MARK: Custom models

private extension DetailViewController {
    private enum CollectionViewSectionIdentifier {
        case languages, genres
    }
    
    private struct CollectionViewItem {
        let title: String
    }
    
    private struct CollectionViewSection {
        let identifier: CollectionViewSectionIdentifier
        let items: [CollectionViewItem]
    }
}

// MARK: UICollectionViewDataSource

extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return languageAndGenreData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languageAndGenreData[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseIdentifier, for: indexPath) as? DetailCollectionViewCell else { fatalError() }
        let item = languageAndGenreData[indexPath.section].items[indexPath.item].title.lowercased().capitalizingFirstLetter()
        
        switch languageAndGenreData[indexPath.section].identifier {
        case .languages:
            cell.configure(title: item, backgroundColor: UIColor(named: "languageBackgroundColor")!, borderColor: UIColor(named: "languageBorderColor")!)
        case .genres:
            cell.configure(title: item, backgroundColor: UIColor(named: "genreBackgroundColor")!, borderColor: UIColor(named: "genreBorderColor")!)
        }
        
        return cell
    }
}
