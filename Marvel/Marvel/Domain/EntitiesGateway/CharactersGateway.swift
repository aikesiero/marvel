//
//  CharactersGateway.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Foundation
import Combine

enum CharactersGatewayError: Error {
    case noResults
}

protocol CharactersGateway {
    func fetchCharacters() -> AnyPublisher<CharactersPage, CharactersGatewayError>
    func fetchCharacters(with query: String) -> AnyPublisher<CharactersPage, CharactersGatewayError>
}
