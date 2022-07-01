//
//  DetailViewController.swift
//  Movies
//
//  Created by Diana Chizhik on 07/06/2022.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    static var identifier: String{NSStringFromClass(self)}
    
    private var selectedMovieID: Int
    private let movieDataService = MovieDataService()
    private  var movieDetails: MovieDetails?
    private var languageAndGenreData = [CollectionViewSection]()
    
    var languagesTest = ["German", "Dutch", "English", "Chinese", "Icelandic", "Russian", "Spanish", "Italian", "Japanese", ]
    var genresTest = ["thriller", "action", "science finction", "romcom", "adventure"]
    
    private lazy var contentView: StackMovieDetailView = {
        let view = StackMovieDetailView()
        view.collectionView.dataSource = self
        return view
    }()

    init(selectedMovieID: Int) {
        self.selectedMovieID = selectedMovieID
        
        super.init(nibName: nil, bundle: nil)
    }
    
//    what does this line mean?
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

        navigationController?.navigationBar.barTintColor = UIColor(named: "backgroundColor")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovieData()
    }
    
    private func loadMovieData() {
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
                    self.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func configureWithData() {
        guard let movieDetails = movieDetails else { return }

        contentView.titleLabel.text = movieDetails.title
        
        if let path = movieDetails.posterPath {
            contentView.imageView.kf.setImage(with: path)
        }
        
        contentView.releaseDateLabel.text = movieDetails.releaseDate
        contentView.durationLabel.text = movieDetails.runtime
        contentView.movieDescriptionLabel.text = movieDetails.overview
       
//        let languages = movieDetails.spokenLanguages.map{ CollectionViewItem(title: $0.englishName) }
//        let genres = movieDetails.genres.map{ CollectionViewItem(title: $0.name) }
        
        let languages = languagesTest.map{ CollectionViewItem(title: $0) }
        let genres = genresTest.map{ CollectionViewItem(title: $0) }
        
        
        let languagesSection = CollectionViewSection(identifier: CollectionViewSectionIdentifier.languages, items: languages)
        let genreSection = CollectionViewSection(identifier: .genres, items: genres)
        languageAndGenreData = [languagesSection, genreSection]
        contentView.collectionView.reloadData()
    }
    
    private func showError(message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }
    
    @objc func dismissView(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        contentView.collectionView.collectionViewLayout.invalidateLayout()
    }
}

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
