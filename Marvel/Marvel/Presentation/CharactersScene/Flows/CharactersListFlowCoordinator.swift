//
//  CharactersListFlowCoordinator.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation
import UIKit

protocol CharactersListViewConnector {
    func navigate(to destination: CharactersListNavigationDestination?)
}

extension CharactersListViewConnector {
    func navigate(to destination: CharactersListNavigationDestination?) { }
}

final class CharactersListFlowCoordinator {

    struct Dependencies {
        let apiNetwork: APINetwork
        let cache: CharactersResponseStorage
    }

    private var navigationController: UINavigationController
    private let dependencies: Dependencies

    init(navigationController: UINavigationController,
         dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let repo = CharactersRepository(network: dependencies.apiNetwork, cache: dependencies.cache)
        let useCaseFactory = CharactersUseCaseFactory(charactersGateway: repo)
        let viewModel = CharactersListViewModel(charactersUseCaseFactory: useCaseFactory, flowCoordinator: self)
        let viewController = CharactersListViewController.create(with: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }

    func navigate(to destination: CharactersListNavigationDestination?) {
        if let destination = destination {
            switch destination {
            case let .detail(index):
                let characterDetailDependencies =
                CharacterDetailFlowCoordinator.Dependencies(apiNetwork: dependencies.apiNetwork,
                                                            cache: dependencies.cache)
                let flow = CharacterDetailFlowCoordinator(navigationController: navigationController,
                                                          dependencies: characterDetailDependencies,
                                                          idCharacter: index)

                flow.start()
            }
        }
    }
}
