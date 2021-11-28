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
    let result: DataDTO
}

extension CharactersResponseDTO {
    struct DataDTO: Decodable {
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
}

extension CharactersResponseDTO {
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
}
