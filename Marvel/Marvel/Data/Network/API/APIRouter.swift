//
//  APIRouter.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation

public enum APIRouter: NetworkCall {

    case getCharacters(apiAuth: APIAuth, request: CharactersRequestDTO)

    var path: URLComponents {
        switch self {
        case let .getCharacters(apiAuth, request):
            var components = URLComponents()
            if let query = request.query {
                let queryString = URLQueryItem(name: "nameStartsWith", value: query)
                components.queryItems = [queryString]
            }
            components.addAuthoriztion(apiAuth: apiAuth)
            components.addPagination(limit: request.limit, offset: request.offset)
            components.path = APIEndpoints.getCharacters
            return components
        }
    }

    var method: HTTPMethodType {
        switch self {
        case .getCharacters:
            return .get
        }
    }

    var headers: [String: String]? {
        return ["Accept": "application/json", "Content-Type": "application/json"]
    }

    func body() throws -> Data? {
        return nil
    }
}
