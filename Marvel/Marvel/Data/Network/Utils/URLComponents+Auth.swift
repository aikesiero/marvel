//
//  URLComponent+Auth.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation
import CryptoKit

extension URLComponents {

    mutating func addAuthoriztion(apiAuth: APIAuth) {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let stringToHash = timestamp + apiAuth.privateKey + apiAuth.publicKey
        let digest = Insecure.MD5.hash(data: stringToHash.data(using: .utf8) ?? Data())
        let hash = digest.map {
                String(format: "%02hhx", $0)
            }.joined()
        var queryItems: [URLQueryItem] = self.queryItems ??  []
        let queryApiKey = URLQueryItem(name: "apikey", value: apiAuth.publicKey)
        let queryHash = URLQueryItem(name: "hash", value: hash)
        let queryTimestamp = URLQueryItem(name: "ts", value: timestamp)
        queryItems.append(queryApiKey)
        queryItems.append(queryHash)
        queryItems.append(queryTimestamp)
        self.queryItems = queryItems
    }
}
