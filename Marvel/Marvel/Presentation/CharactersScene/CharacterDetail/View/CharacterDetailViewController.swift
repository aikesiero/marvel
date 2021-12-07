//
//  CharacterDetailViewController.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 1/12/21.
//

import UIKit
import Combine

final class CharacterDetailViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameView: UIView!

    private var bindings = Set<AnyCancellable>()

    private var viewModel: CharacterDetailViewModel!

    static func create(with viewModel: CharacterDetailViewModel) -> CharacterDetailViewController {
        let view = CharacterDetailViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func bind(to viewModel: CharacterDetailViewModel) {

        func bindViewModelToView() {
            viewModel.$character
                .receive(on: Scheduler.mainScheduler)
                .sink(receiveValue: { [weak self] _ in
                    self?.updateItems()
                })
                .store(in: &bindings)

            let stateValueHandler: (CharactersListViewModelState) -> Void = { [weak self] state in
                switch state {
                case .noResults:
                    LoadingView.hide()
                case .loading:
                    LoadingView.show()
                    self?.nameView.isHidden = true
                case .finishedLoading:
                    LoadingView.hide()
                    self?.nameView.isHidden = false
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
        let backImage = UIImage(systemName: "chevron.left")
        let newBtn = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftItemsSupplementBackButton = false
        self.navigationItem.leftBarButtonItem = newBtn
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    private func updateItems() {
        self.nameLabel.text = viewModel.character?.name
        self.descriptionLabel.text = viewModel.character?.description
        guard let urlImage = URL(string: viewModel.character?.imageURL ?? "") else {
            return
        }

        imageView.load(url: urlImage)
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
