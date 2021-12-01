//
//  AppDIContainer.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Foundation

final class AppDIContainer {

    lazy var appConfiguration = AppConfiguration()

    // MARK: - Network
    lazy var apiNetwork: APINetwork = {
        return APINetwork(baseURL: appConfiguration.apiBaseURL,
                   publicKey: appConfiguration.apiPublicKey,
                   privateKey: appConfiguration.apiPrivateKey)
    }()

    // MARK: - Persisten Storage
    lazy var charactersResponseCache: CharactersResponseStorage = {
        return CoreDataCharactersResponseStorage()
    }()
}
