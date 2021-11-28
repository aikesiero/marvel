//
//  StatusCode.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation

struct StatusCode {

    struct Success {
        static let success: Int = 200
        static let created: Int = 201
        static let noContent: Int = 204
    }

    struct Failure {
        // Standard
        static let invalidRequest: Int = 400
        static let unauthorized: Int = 401
        static let forbidden: Int = 403
        static let urlNotFound: Int = 404
        static let serverError: Int = 500

        // API
        static let apiError: Int = 409
        
        // System
        static let cancelled: Int = -999
        static let notConnectedWithServer: Int = -1009
    }
}
