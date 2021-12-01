//
//  CharactersListFlowCoordinator.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation
import UIKit

final class CharactersListFlowCoordinator {

    struct Dependencies {
        let apiNetwork: APINetwork
        let cache: CharactersResponseStorage
    }

    private weak var navigationController: UINavigationController?
    private let dependencies: Dependencies

    init(navigationController: UINavigationController,
         dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let repo = CharactersRepository(network: dependencies.apiNetwork, cache: dependencies.cache)
        let useCaseFactory = CharactersUseCaseFactory(charactersGateway: repo)
        let viewModel = CharactersListViewModel(charactersUseCaseFactory: useCaseFactory)
        let viewController = CharactersListViewController.create(with: viewModel)
        navigationController?.pushViewController(viewController, animated: false)
    }
}
