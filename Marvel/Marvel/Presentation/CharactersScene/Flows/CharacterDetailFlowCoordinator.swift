//
//  CharacterDetailFlowCoordinator.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 1/12/21.
//

import Foundation
import UIKit

final class CharacterDetailFlowCoordinator {

    struct Dependencies {
        let apiNetwork: APINetwork
        let cacheResponse: CharactersResponseStorage
        let cacheCharacter: CharacterDetailStorage
    }

    private var navigationController: UINavigationController
    private let dependencies: Dependencies
    private let idCharacter: Int

    init(navigationController: UINavigationController,
         dependencies: Dependencies,
         idCharacter: Int) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.idCharacter = idCharacter
    }

    func start() {
        let repo = CharactersRepository(network: dependencies.apiNetwork,
                                        cacheResponse: dependencies.cacheResponse,
                                        cacheCharacter: dependencies.cacheCharacter)
        let useCaseFactory = CharactersUseCaseFactory(charactersGateway: repo)
        let viewModel = CharacterDetailViewModel(charactersUseCaseFactory: useCaseFactory, idCharacter: idCharacter)
        let viewController = CharacterDetailViewController.create(with: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
