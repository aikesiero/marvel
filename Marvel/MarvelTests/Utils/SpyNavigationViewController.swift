//
//  SpyNavigationViewController.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import UIKit

class SpyNavigationController: UINavigationController {

    var pushedViewController: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: true)
    }
}
