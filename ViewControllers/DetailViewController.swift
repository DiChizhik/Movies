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
    
    var selectedMovieId: Int?
    var movieDetails: MovieDetails?
    var languages = [String]()
    var languagesTest = ["German", "Dutch", "English", "Chinese", "Icelandic", "Russian", "Spanish", "Italian", "Japanese", ]
    var genres = [String]()
    var genresTest = ["thriller", "action", "science finction", "romcom", "adventure"]
    
    let movieDataService = MovieDataService()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: view.bounds)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = UIColor(named: "backgroundColor")
        return scroll
    }()
    
    private lazy var contentView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Movie Title"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var releasedOnLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "staticTextColor")
        label.text = "Released on"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "descriptionColor")
        label.text = "date"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var lastsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "staticTextColor")
        label.text = "Lasts"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "descriptionColor")
        label.text = "0h0"
        label.textAlignment = .left
        return label
    }()
    
    private lazy var movieDescriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 0
        description.font = UIFont.systemFont(ofSize: 15)
        description.textColor = UIColor(named: "descriptionColor")
        description.textAlignment = .left
        description.text = """
                        a very
                        thought-provocing
                        black-humoured
                        romcom
                        """
        return description
    }()
    
    private lazy var collectionViewFlowLayout: AlignedCollectionViewFlowLayout = {
        let layout = AlignedCollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.horizontalAlignment = .left
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "backgroundColor")
        return collectionView
    }()
    
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
    
    private lazy var viewData: [CollectionViewSection] = makeViewData()
    
    private func makeViewData() -> [CollectionViewSection] {
        let languages: [CollectionViewItem] = languages.map{CollectionViewItem(title: $0)}
        let languagesSection = CollectionViewSection(identifier: CollectionViewSectionIdentifier.languages, items: languages)
        
        let genres: [CollectionViewItem] = genres.map{CollectionViewItem(title: $0)}
        let genreSection = CollectionViewSection(identifier: .genres, items: genres)
    
        return [languagesSection, genreSection]
        }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let id = selectedMovieId else { return }
        
        movieDataService.getMovieDetails(movieId: id) { [weak self] result in
            guard let self = self else {return}
                
            switch result {
            case .success(let details):
                self.movieDetails = details
            case .failure(let error):
                switch error {
                case .failedToGetResponse:
                    self.showError(message: error.localizedDescription)
                case .failedToDecode:
                    self.showError(message: error.localizedDescription)
                case .failedToGetData:
                    self.showError(message: error.localizedDescription)
                }
            }
            
            DispatchQueue.main.async {
                self.configureWithData()
                self.setupUI()
            }
        }
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

        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupUI() {
        let exitButton = UIButton.systemButton(with: UIImage(systemName: "xmark")!, target: self, action: #selector(dismissView))
        exitButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: exitButton)
        
        navigationController?.navigationBar.barTintColor = UIColor(named: "backgroundColor")
        
        view.backgroundColor = UIColor(named: "backgroundColor")

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        let releaseStack = UIStackView()
        releaseStack.translatesAutoresizingMaskIntoConstraints = false
        releaseStack.axis = .horizontal
        releaseStack.spacing = 4
        releaseStack.addArrangedSubview(releasedOnLabel)
        releaseStack.addArrangedSubview(releaseDateLabel)
        
        let durationStack = UIStackView()
        durationStack.translatesAutoresizingMaskIntoConstraints = false
        durationStack.axis = .horizontal
        durationStack.spacing = 4
        durationStack.addArrangedSubview(lastsLabel)
        durationStack.addArrangedSubview(durationLabel)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(releaseStack)
        contentView.addSubview(durationStack)
        contentView.addSubview(movieDescriptionLabel)
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),

            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.61),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.41),
            
            releaseStack.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            releaseStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 35),

            durationStack.leftAnchor.constraint(equalTo: releaseStack.leftAnchor),
            durationStack.topAnchor.constraint(equalTo: releaseStack.bottomAnchor, constant: 8),

            movieDescriptionLabel.leftAnchor.constraint(equalTo: releaseStack.leftAnchor),
            movieDescriptionLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
            movieDescriptionLabel.topAnchor.constraint(equalTo: durationStack.bottomAnchor, constant: 16),

            collectionView.leftAnchor.constraint(equalTo: releaseStack.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: movieDescriptionLabel.bottomAnchor, constant: 16),
            collectionView.rightAnchor.constraint(equalTo: movieDescriptionLabel.rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: calculateCollectionViewHeight())
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: calculateScrollViewContentSize())
    }
    
    private func calculateCollectionViewHeight()-> CGFloat {
        var languageRows = languages.count / 4
        languages.count % 4 != 0 ? languageRows += 1 : nil
        let languageRowsHeight = (languageRows * 27) + ((languageRows - 1) * 4)
        
        var genreRows = genres.count / 4
        genres.count % 4 != 0 ? genreRows += 1 : nil
        let genreRowsHeight = (genreRows * 27) + ((genreRows - 1) * 4)
        
        return CGFloat(languageRowsHeight + 16 + genreRowsHeight)
    }
    
    private func calculateScrollViewContentSize()-> CGFloat {
        let lastItemOrigin = collectionView.frame.origin.y
        let lastItemHeight = collectionView.frame.size.height
        
        print(lastItemHeight)
        
        let scrollViewContentSize = lastItemHeight + lastItemOrigin
        return scrollViewContentSize
    }
    
    private func configureWithData() {
        guard let movieDetails = movieDetails else { return }

        titleLabel.text = movieDetails.title
        
        if let path = movieDetails.posterPath {
            imageView.kf.setImage(with: path)
        }
        
        releaseDateLabel.text = movieDetails.releaseDate
        durationLabel.text = movieDetails.runtime
        movieDescriptionLabel.text = movieDetails.overview
        languages = movieDetails.spokenLanguages.map{$0.englishName}
        genres = movieDetails.genres.map{$0.name}
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        assert(!languages.isEmpty, "Languages array is empty")
        return viewData[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseIdentifier, for: indexPath) as? DetailCollectionViewCell else { fatalError() }
        let item = viewData[indexPath.section].items[indexPath.item].title.lowercased().capitalizingFirstLetter()
        
        switch viewData[indexPath.section].identifier {
        case .languages:
            cell.configure(title: item, backgroundColor: UIColor(named: "languageBackgroundColor")!, borderColor: UIColor(named: "languageBorderColor")!)
        case .genres:
            cell.configure(title: item, backgroundColor: UIColor(named: "genreBackgroundColor")!, borderColor: UIColor(named: "genreBorderColor")!)
        }
        
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = viewData[indexPath.section].items[indexPath.item].title.lowercased().capitalizingFirstLetter()
        
        return CGSize(width: item.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]).width + 31, height: item.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]).height + 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
    }
}
