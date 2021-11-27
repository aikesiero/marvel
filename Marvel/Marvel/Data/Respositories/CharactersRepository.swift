//
//  CharactersRepository.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Foundation
import Combine

final class CharactersRepository {

    // TODO: provisional

    let cPage: CharactersPage = CharactersPage(page: 1, totalPages: 2, characters: [Character(id: 1, name: "pruebaA"),
                                                                                    Character(id: 2, name: "pruebaB")])

}

extension CharactersRepository: CharactersGateway {
    func fetchCharacters() -> AnyPublisher<CharactersPage, CharactersGatewayError> {
        // TODO: provisional
        return Just(cPage)
            .setFailureType(to: CharactersGatewayError.self)
            .delay(for: 2, scheduler: Scheduler.backgroundWorkScheduler)
            .eraseToAnyPublisher()

    }

    func fetchCharacters(with query: String) -> AnyPublisher<CharactersPage, CharactersGatewayError> {
        // TODO: provisional
        return Just(cPage)
            .setFailureType(to: CharactersGatewayError.self)
            .delay(for: 2, scheduler: Scheduler.backgroundWorkScheduler)
            .eraseToAnyPublisher()
    }

}
