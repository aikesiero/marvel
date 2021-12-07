//
//  URLComponents+Pagination.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 29/11/21.
//

import Foundation
import CryptoKit

extension URLComponents {

    mutating func addPagination(limit: Int, offset: Int) {
        var queryItems: [URLQueryItem] = self.queryItems ??  []
        let querySize = URLQueryItem(name: "limit", value: String(limit))
        let queryOffset = URLQueryItem(name: "offset", value: String(offset))
        queryItems.append(querySize)
        queryItems.append(queryOffset)
        self.queryItems = queryItems
    }
}
