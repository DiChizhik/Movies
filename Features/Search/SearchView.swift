//
//  SearchTableView.swift
//  Movies
//
//  Created by Diana Chizhik on 12/07/2022.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func startSearching(for text: String)
}

class SearchView: UIView {
    private(set) lazy var searchController: UISearchController = {
       let search = UISearchController(searchResultsController: nil)
        search.obscuresBackgroundDuringPresentation = false
        search.automaticallyShowsCancelButton = true
        search.hidesNavigationBarDuringPresentation = false
        search.searchBar.placeholder = "Type movie name"
        search.searchBar.tintColor = UIColor(named: "titleColor")
        search.searchBar.searchTextField.addTarget(self, action: #selector(startSearching), for: .editingDidEnd)
        return search
    }()
    
    private(set) lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "backgroundColor")
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
    
    private func setupUI() {
        backgroundColor = UIColor(named: "backgroundColor")
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func startSearching() {
        guard let text = searchController.searchBar.text else { return }
        
        delegate?.startSearching(for: text)
    }
    
}
