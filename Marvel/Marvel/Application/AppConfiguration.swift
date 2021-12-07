//
//  AppConfiguration.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 24/11/21.
//

import Foundation
enum FatalErrorMessage: String {
    case apiPublicKey = "ApiPublicKey must not be empty in plist"
    case apiPrivateKey = "ApiPrivateKey must not be empty in plist"
    case apiBaseURL = "ApiBaseURL must not be empty in plist"
}
final class AppConfiguration {

    let mainBundle: Bundle

    init() {
        self.mainBundle = Bundle.main
    }

    init(bundle: Bundle) {
        self.mainBundle = bundle
    }

    lazy var apiPublicKey: String = {
        guard let apiKey = mainBundle.object(forInfoDictionaryKey: "ApiPublicKey") as? String else {
            fatalError(FatalErrorMessage.apiPublicKey.rawValue)
        }
        return apiKey
    }()

    lazy var apiPrivateKey: String = {
        guard let apiKey = mainBundle.object(forInfoDictionaryKey: "ApiPrivateKey") as? String else {
            fatalError(FatalErrorMessage.apiPrivateKey.rawValue)
        }
        return apiKey
    }()

    lazy var apiBaseURL: String = {
        guard let apiBaseURL = mainBundle.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError(FatalErrorMessage.apiBaseURL.rawValue)
        }
        return apiBaseURL
    }()
}
