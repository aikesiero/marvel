//
//  CharactersQuery.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 29/11/21.
//

import Foundation

struct CharactersQuery: Equatable {
    var query: String?
    var page: Int = 1
    let pageSize: Int = 20
}

extension CharactersQuery {
    mutating func nextPage() {
        page += 1
    }

    mutating func reset() {
        page = 1
        query = nil
    }
}
