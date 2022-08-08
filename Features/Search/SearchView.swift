//
//  SearchTableView.swift
//  Movies
//
//  Created by Diana Chizhik on 12/07/2022.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func startSearching(_ searchView: SearchView, for text: String)
}

class SearchView: UIView {
    var tableViewDelegate: UITableViewDelegate? {
        get {
            tableView.delegate
        }
        set {
            tableView.delegate = newValue
        }
    }
    var tableViewDataSource: UITableViewDataSource? {
        get {
            tableView.dataSource
        }
        set {
            tableView.dataSource = newValue
        }
    }
    
    private(set) lazy var searchController: UISearchController = {
       let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.automaticallyShowsCancelButton = true
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Type movie name"
        search.searchBar.tintColor = .whiteF5
        search.searchBar.searchTextField.addTarget(self, action: #selector(startSearching), for: .editingDidEnd)
        return search
    }()
    
    private(set) lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .darkBlue01
        tableView.register(SearchTableViewCell.self)
        tableView.rowHeight = 150
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    weak var delegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
}

// MARK: - Private functions
extension SearchView {
    func setupUI() {
        backgroundColor = .darkBlue01
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func startSearching() {
        guard let text = searchController.searchBar.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        delegate?.startSearching(self, for: text)
    }
}
