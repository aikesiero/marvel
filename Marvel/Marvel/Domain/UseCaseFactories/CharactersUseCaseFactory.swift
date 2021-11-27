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
    func fetchCharactersUseCase(handler: @escaping Handler<CharactersPage>) -> UseCase {
        SearchCharactersUseCase(charactersGateway: charactersGateway, handler: handler)
    }
}
