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
        case thumbnail
    }
    let id: Int
    let name: String
    let description: String?
    let thumbnail: Thumbnail?
}

struct Thumbnail: Decodable {
    private enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
    let path: String
    let ext: String
}

// MARK: - Mappings to Domain

extension CharacterDTO {
    func toDomain() -> Character {
        guard let imagePath = thumbnail?.path,
              let imageExtension = thumbnail?.ext else {
                  return .init(id: id, name: name, description: description, imageUrl: nil)
        }
        let urlImage = imagePath + "." + imageExtension
        return .init(id: id, name: name, description: description, imageUrl: urlImage)
    }
}
