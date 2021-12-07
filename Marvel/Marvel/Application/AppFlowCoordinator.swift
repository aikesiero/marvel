//
//  AppConnector.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 24/11/21.
//

import Foundation
import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let characterListDependencies =
        CharactersListFlowCoordinator.Dependencies(apiNetwork: appDIContainer.apiNetwork,
                                                   cacheResponse: appDIContainer.charactersResponseCache,
                                                   cacheCharacter: appDIContainer.characterDetailCache)
        let flow = CharactersListFlowCoordinator(navigationController: navigationController,
                                      dependencies: characterListDependencies)

        flow.start()
    }
}
