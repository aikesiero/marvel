//
//  NetworkCall.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Foundation

protocol NetworkCall {
    var path: URLComponents { get }
    var method: HTTPMethodType { get }
    var headers: [String: String]? { get }
    func body() throws -> Data?
}

extension NetworkCall {
    func urlRequest(baseURL: String) throws -> URLRequest {
        var urlComponent = path
        if baseURL != "" {
            urlComponent.scheme = "https"
            urlComponent.host = baseURL
        }
        guard let url = urlComponent.url else {
            throw NetworkError.urlNotFound(urlComponent.url?.absoluteString ?? "")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()
        Log.networkRequest(request: request)
        return request
    }
}

public typealias HTTPCode = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
    static let success = 200 ..< 300
}

public enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
