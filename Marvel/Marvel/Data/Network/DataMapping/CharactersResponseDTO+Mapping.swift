//
//  CharactersResponseDTO+Mapping.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 28/11/21.
//

import Foundation

// MARK: - Data Transfer Object

struct CharactersResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case code
        case status
        case result = "data"
    }
    let code: Int
    let status: String
    let result: CharactersDataDTO
}

// MARK: - Mappings to Domain

extension CharactersResponseDTO {
    func toDomain() -> CharactersPage {
        return result.toDomain()
    }

    func firstElement() -> Character? {
        guard let firsElement = result.characters.first else {
            return nil
        }
        return firsElement.toDomain()
    }
}
