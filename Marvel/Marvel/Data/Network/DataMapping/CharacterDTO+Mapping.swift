//
//  CharacterDTO+Mapping.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation

// MARK: - Data Transfer Object

struct CharacterDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
    }
    let id: Int
    let name: String
    let description: String?
}

// MARK: - Mappings to Domain

extension CharacterDTO {
    func toDomain() -> Character {
        return .init(id: id, name: name)
    }
}
