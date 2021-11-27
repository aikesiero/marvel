//
//  CharactersListViewController.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 24/11/21.
//

import UIKit
import Combine

final class CharactersListViewController: UIViewController, UISearchControllerDelegate {

    @IBOutlet private var searchBarContainer: UIView!

    private var bindings = Set<AnyCancellable>()

    private var viewModel: CharactersListViewModel!

    private var searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifecycle

    static func create(with viewModel: CharactersListViewModel) -> CharactersListViewController {
        let viewController = CharactersListViewController.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func bind(to viewModel: CharactersListViewModel) {

        func bindViewModelToView() {
            viewModel.$characters
                .receive(on: Scheduler.mainScheduler)
                .sink(receiveValue: { [weak self] _ in
                    self?.updateItems()
                })
                .store(in: &bindings)

            let stateValueHandler: (CharactersListViewModelState) -> Void = { [weak self] state in
                switch state {
                case .loading:
                    // TODO:loading
                    Log.debug("loading")
                case .finishedLoading:
                    // TODO: finishedLoading
                    Log.debug("finishedLoading")
                case .error(let error):
                    self?.showError(error)
                }
            }

            viewModel.$state
                .receive(on: Scheduler.mainScheduler)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
        }

        bindViewModelToView()
    }

    // MARK: - Private

    private func setUpViews() {
        title = viewModel.screenTitle.uppercased()
        setupSearchController()
    }

    private func updateItems() {
        // TODO: reload
        //  tableViewController?.reload()
    }

    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Search Controller

extension CharactersListViewController {
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.searchBar.barTintColor = .mainColor
        searchController.searchBar.tintColor = .lightTextColor
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifier.searchField
        }

        let placholderAttribute = [ NSAttributedString.Key.foregroundColor:
                                        UIColor.placeholderColor ?? .white] as [NSAttributedString.Key: Any]
        let placeholderAttrString = NSAttributedString(string: viewModel.searchBarPlaceholder,
                                                       attributes: placholderAttribute)

        searchController.searchBar.searchTextField.attributedPlaceholder = placeholderAttrString
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .lightTextColor
        searchController.searchBar.searchTextField.rightView?.tintColor = .white

        if let clearButton = searchController.searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = .lightTextColor
        }
    }
}

extension CharactersListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
//        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}
