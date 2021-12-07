//
//  CharactersDataDTO+Mapping.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation

// MARK: - Data Transfer Object

struct CharactersDataDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case characters = "results"
    }
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let characters: [CharacterDTO]
}

// MARK: - Mappings to Domain

extension CharactersDataDTO {
    func toDomain() -> CharactersPage {
        let page = (offset / limit) + 1
        let totalPages = (total / limit)
        return .init(page: page,
                     totalPages: totalPages,
                     characters: characters.map { $0.toDomain() })
    }
}
