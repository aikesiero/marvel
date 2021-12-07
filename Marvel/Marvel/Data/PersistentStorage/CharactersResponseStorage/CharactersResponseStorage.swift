//
//  CharactersResponseStorage.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 1/12/21.
//

import Foundation
import Combine

protocol CharactersResponseStorage {
    func getResponse(for requestDTO: CharactersRequestDTO) -> AnyPublisher<CharactersResponseDTO, CoreDataStorageError>
    func save(response: CharactersResponseDTO, for request: CharactersRequestDTO)
}
