//
//  CharactersListTableViewController.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import UIKit

final class CharactersListTableViewController: UITableViewController {

    var viewModel: MoviesListViewModel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func reload() {
        tableView.reloadData()
    }
    
    // MARK: - Private
    
    private func setupViews() {
        tableView.estimatedRowHeight = MoviesListItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
}
