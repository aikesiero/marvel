//
//  CharacterDetailStorage.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 2/12/21.
//

import Foundation
import Combine

protocol CharacterDetailStorage {
    func getCharacter(for id: Int) -> AnyPublisher<CharacterDTO, CoreDataStorageError>
    func save(character: CharacterDTO)
}
