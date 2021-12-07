//
//  CharactersResponseStorageDummy.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import Combine
@testable import Marvel

class CharactersResponseStorageDummy: CharactersResponseStorage {
    func getResponse(for requestDTO: CharactersRequestDTO)
    -> AnyPublisher<CharactersResponseDTO, CoreDataStorageError> {
        Empty().setFailureType(to: CoreDataStorageError.self).eraseToAnyPublisher()
    }

    func save(response: CharactersResponseDTO, for request: CharactersRequestDTO) {}
}
