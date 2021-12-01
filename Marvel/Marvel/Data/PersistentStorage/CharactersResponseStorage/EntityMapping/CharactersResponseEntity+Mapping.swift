//
//  CharactersResponseEntity+Mapping.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 1/12/21.
//

import Foundation
import CoreData

// MARK: - Entities to DTO

extension CharactersResponseEntity {

    func toDTO() -> CharactersResponseDTO {
        return .init(code: Int(code),
                     status: status ?? "",
                     result: result!.toDTO())
    }
}

extension CharactersDataResponseEntity {
    func toDTO() -> CharactersDataDTO {

        let charactersArray = characters?
            .allObjects
            .map { ($0 as? CharacterResponseEntity)!.toDTO() } ?? []

        let sortedCharacters = charactersArray.sorted(by: {$0.name < $1.name})
        return .init(offset: Int(offset),
                     limit: Int(limit),
                     total: Int(total),
                     count: Int(count),
                     characters: sortedCharacters
        )
    }
}

extension CharacterResponseEntity {
    func toDTO() -> CharacterDTO {
        return .init(id: Int(id),
                     name: name ?? "",
                     description: desc)
    }
}

// MARK: - DTO to Entities

extension CharactersRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> CharactersRequestEntity {
        let entity: CharactersRequestEntity = .init(context: context)
        entity.limit = Int32(limit)
        entity.offset = Int32(offset)
        entity.query = query ?? ""
        return entity
    }
}

extension CharactersResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> CharactersResponseEntity {
        let entity: CharactersResponseEntity = .init(context: context)
        entity.code = Int32(code)
        entity.status = status
        entity.result = result.toEntity(in: context)
        return entity
    }
}

extension CharactersDataDTO {
    func toEntity(in context: NSManagedObjectContext) -> CharactersDataResponseEntity {
        let entity: CharactersDataResponseEntity = .init(context: context)
        entity.offset = Int32(offset)
        entity.limit = Int32(limit)
        entity.total = Int32(total)
        entity.count = Int32(count)
        characters.forEach {
            entity.addToCharacters($0.toEntity(in: context))
        }
        return entity
    }
}

extension CharacterDTO {
    func toEntity(in context: NSManagedObjectContext) -> CharacterResponseEntity {
        let entity: CharacterResponseEntity = .init(context: context)
        entity.id = Int64(id)
        entity.name = name
        entity.desc = description
        return entity
    }
}
