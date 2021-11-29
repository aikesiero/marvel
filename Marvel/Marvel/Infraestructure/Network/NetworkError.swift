//
//  NetworkError.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation

enum NetworkError: Error {
    case httpCode(HTTPCode, String)
    case imageProcessing([URLRequest])
    case invalidRequest(errors: [String])
    case unauthorized(String)
    case forbidden(String)
    case urlNotFound(String)
    case serverError(String)
    case apiError(String, String)
    case unknownError

    static func checkErrorCode(_ errorCode: Int, _ message: String, _ code: String = "") -> NetworkError {
        switch errorCode {
        case StatusCode.Failure.invalidRequest:
            return .invalidRequest(errors: [])
        case StatusCode.Failure.unauthorized:
            return .unauthorized(message)
        case StatusCode.Failure.forbidden:
            return .forbidden(message)
        case StatusCode.Failure.urlNotFound:
            return .urlNotFound(message)
        case StatusCode.Failure.serverError:
            return .serverError(message)
        case StatusCode.Failure.apiError:
            return .apiError(code, message)
        default:
            return .unknownError
        }
    }

    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRequest(errors: _), .invalidRequest(errors: _)):
            return true
        case (.unauthorized, .unauthorized):
            return true
        case (.forbidden, .forbidden):
            return true
        case (.urlNotFound, .urlNotFound):
            return true
        case (.serverError, .serverError):
            return true
        case (.unknownError, .unknownError):
            return true
        default:
            return false
        }
    }
}

struct NetworkErrorMessage: Codable, Equatable {
    let code: String
    let message: String
}

extension NetworkErrorMessage {
    public var errorMessage: String { message }
}
