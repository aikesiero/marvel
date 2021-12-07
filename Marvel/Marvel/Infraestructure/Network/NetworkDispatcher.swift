//
//  NetworkDispatcher.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation
import Combine

protocol NetworkDispatcher {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension NetworkDispatcher {
    func call<Value>(endpoint: NetworkCall, httpCodes: HTTPCodes = .success) -> AnyPublisher<Value, Error>
    where Value: Decodable {
        do {
            let request = try endpoint.urlRequest(baseURL: baseURL)
            return session
                .dataTaskPublisher(for: request)
                .requestJSON(httpCodes: httpCodes)
        } catch let error {
            return Fail<Value, Error>(error: error).eraseToAnyPublisher()
        }
    }

}

// MARK: - Helpers
private extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {

        return tryMap {
            assert(!Thread.isMainThread)

            guard let response = $0.1 as? HTTPURLResponse else {
                Log.networkError("Error unexpected Response")
                throw NetworkError.unknownError
            }
            Log.networkResponse(response: response, data: $0.0, httpCodes: httpCodes)

            guard let code = ($0.1 as? HTTPURLResponse)?.statusCode else {
                Log.networkError("Error unexpected Response")
                throw NetworkError.unknownError
            }

            guard httpCodes.contains(code) else {
                Log.networkError("Error found: \(code)")
                var errorNet: NetworkError
                do {
                    let errorM = try JSONDecoder().decode(NetworkErrorMessage.self, from: $0.0)
                    errorNet = NetworkError.checkErrorCode(code, errorM.message, errorM.code)
                } catch {
                    throw NetworkError.checkErrorCode(code, "")
                }
                throw errorNet
            }

            return $0.0
        }
        .decode(type: Value.self, decoder: JSONDecoder())
        .extractUnderlyingError()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
