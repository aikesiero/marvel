//
//  APIRouter.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation

public enum APIRouter: NetworkCall {

    case getCharacters(apiAuth: APIAuth)

    var path: URLComponents {
        switch self {
        case let .getCharacters(apiAuth: apiAuth):
            var components = URLComponents()
            components.addAuthoriztion(apiAuth: apiAuth)
            components.path = APIEndpoints.getCharacters
            return components
        }
    }

    var method: String {
        switch self {
        case .getCharacters:
            return "GET"
        }
    }

    var headers: [String: String]? {
        return ["Accept": "application/json", "Content-Type": "application/json"]
    }

    func body() throws -> Data? {
        return nil
    }
}
