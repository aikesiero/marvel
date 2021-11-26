//
//  CharactersListViewController.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 24/11/21.
//

import UIKit

final class CharactersListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        lazy var appConfiguration = AppConfiguration()
        Log.debug(appConfiguration.apiPublicKey)
    }
}
