//
//  CharactersListTableViewController.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import UIKit

final class CharactersListTableViewController: UITableViewController {

    var viewModel: CharactersListViewModel!
    var nextPageLoadingSpinner: UIActivityIndicatorView?

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
        tableView.estimatedRowHeight = CharactersListItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }

    func updateLoading(_ loading: CharactersListViewModelLoading) {
        switch loading {
        case .nextPage:
            nextPageLoadingSpinner?.removeFromSuperview()
            nextPageLoadingSpinner = makeActivityIndicator(size: .init(width: tableView.frame.width, height: 44))
            tableView.tableFooterView = nextPageLoadingSpinner
        case .fullScreen, .none:
            tableView.tableFooterView = nil
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CharactersListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersListItemCell.reuseIdentifier,
                                                       for: indexPath) as? CharactersListItemCell else {
            assertionFailure("""
                             Cannot dequeue reusable cell
                             \(CharactersListItemCell.self)
                             with reuseIdentifier:
                             \(CharactersListItemCell.reuseIdentifier)
                             """)
            return UITableViewCell()
        }

        cell.fill(with: viewModel.characters[indexPath.row])

        if indexPath.row == viewModel.characters.count - 1 {
            viewModel.didLoadNextPage()
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.characters.isEmpty ?
        tableView.frame.height :
        super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCharacter(at: indexPath.row)
    }
}
