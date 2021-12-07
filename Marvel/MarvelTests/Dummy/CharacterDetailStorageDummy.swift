//
//  CharacterDetailStorageDummy.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import Combine
@testable import Marvel

class CharacterDetailStorageDummy: CharacterDetailStorage {

    func getCharacter(for id: Int) -> AnyPublisher<CharacterDTO, CoreDataStorageError> {
        Empty().setFailureType(to: CoreDataStorageError.self).eraseToAnyPublisher()
    }

    func save(character: CharacterDTO) {}
}
