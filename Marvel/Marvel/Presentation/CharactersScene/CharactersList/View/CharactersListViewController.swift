//
//  CharactersListViewController.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 24/11/21.
//

import UIKit
import Combine

final class CharactersListViewController: UIViewController, StoryboardInstantiable, UISearchControllerDelegate {

    @IBOutlet private var searchBarContainer: UIView!
    @IBOutlet private var charactersListContainer: UIView!
    @IBOutlet private var emptyDataLabel: UILabel!

    private var bindings = Set<AnyCancellable>()

    private var viewModel: CharactersListViewModel!

    private var searchController = UISearchController(searchResultsController: nil)

    private var charactersTableViewController: CharactersListTableViewController?

    // MARK: - Lifecycle

    static func create(with viewModel: CharactersListViewModel) -> CharactersListViewController {
        let viewController = CharactersListViewController.instantiateViewController()
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

            viewModel.$loading
                .receive(on: Scheduler.mainScheduler)
                .sink(receiveValue: { [weak self] loading in
                    self?.updateLoading(loading)
                })
                .store(in: &bindings)

            let stateValueHandler: (CharactersListViewModelState) -> Void = { [weak self] state in
                switch state {
                case .noResults:
                    self?.emptyDataLabel.text = viewModel.noResultsTitle
                case .finishedLoading, .loading:
                    self?.emptyDataLabel.text = viewModel.emptyDataTitle
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: CharactersListTableViewController.self),
            let destinationVC = segue.destination as? CharactersListTableViewController {
            charactersTableViewController = destinationVC
            charactersTableViewController?.viewModel = viewModel
        }
    }

    // MARK: - Private

    private func setUpViews() {
        title = viewModel.screenTitle.uppercased()
        setupSearchController()
    }

    private func updateItems() {
        charactersTableViewController?.reload()
    }

    private func updateLoading(_ loading: CharactersListViewModelLoading) {
        emptyDataLabel.isHidden = true
        charactersListContainer.isHidden = true
        LoadingView.hide()
        switch loading {
        case .fullScreen: LoadingView.show()
        case .nextPage: charactersListContainer.isHidden = false
        case .none:
            charactersListContainer.isHidden = viewModel.characters.isEmpty
            emptyDataLabel.isHidden = !viewModel.characters.isEmpty
        }
        charactersTableViewController?.updateLoading(loading)
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

        let customFont = UIFont(name: "My Olivin", size: 24) ?? UIFont.systemFont(ofSize: 15.0)

        let placholderAttribute = [.foregroundColor:
                                        UIColor.placeholderColor ?? .white,
                                    .font: customFont] as [NSAttributedString.Key: Any]

        let cancelAttribute = [.foregroundColor: UIColor.white,
                               .font: customFont] as [NSAttributedString.Key: Any]

        let placeholderAttrString = NSAttributedString(string: viewModel.searchBarPlaceholder,
                                                       attributes: placholderAttribute)

        searchController.searchBar.searchTextField.attributedPlaceholder = placeholderAttrString
        searchController.searchBar.searchTextField.font = customFont
        searchController.searchBar.searchTextField.leftView?.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .lightTextColor
        searchController.searchBar.searchTextField.rightView?.tintColor = .white

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .setTitleTextAttributes(cancelAttribute, for: .normal)

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
        viewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}
