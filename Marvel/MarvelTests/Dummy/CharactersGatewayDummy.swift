//
//  CharactersGatewayDummy.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import Combine
@testable import Marvel

class CharactersGatewayDummy: CharactersGateway {
    func fetchCharacters(with query: CharactersQuery) -> AnyPublisher<CharactersPage, CharactersGatewayError> {
        Empty().setFailureType(to: CharactersGatewayError.self).eraseToAnyPublisher()
    }

    func fetchCharacter(with id: Int) -> AnyPublisher<Character, CharactersGatewayError> {
        Empty().setFailureType(to: CharactersGatewayError.self).eraseToAnyPublisher()
    }
}
