//
//  CharactersUseCaseFactory.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Foundation

class CharactersUseCaseFactory {

    // MARK: - Properties
    let charactersGateway: CharactersGateway

    // MARK: - Initializer
    init(charactersGateway: CharactersGateway) {
        self.charactersGateway = charactersGateway
    }

    // MARK: - Factory Methods
    func fetchCharactersUseCase(query: CharactersQuery,
                                handler: @escaping Handler<CharactersPage>) -> UseCase {
        SearchCharactersUseCase(query: query,
                                charactersGateway: charactersGateway,
                                handler: handler)
    }

    func fetchCharacterUseCase(id: Int,
                               handler: @escaping Handler<Character>) -> UseCase {
        GetCharacterUseCase(id: id,
                            charactersGateway: charactersGateway,
                            handler: handler)
    }
}
