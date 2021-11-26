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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

        // TODO: Modificar
        let viewController = CharactersListViewController()
        navigationController.pushViewController(viewController, animated: false)

    }
}
