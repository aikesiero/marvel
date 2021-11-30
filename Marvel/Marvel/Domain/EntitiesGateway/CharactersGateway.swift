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
    case networkError
}

protocol CharactersGateway {
    func fetchCharacters(with query: CharactersQuery) -> AnyPublisher<CharactersPage, CharactersGatewayError>
}
