//
//  SearchCharactersUseCase.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Combine

final class SearchCharactersUseCase {
    // MARK: - Properties
    private let charactersGateway: CharactersGateway
    private let query: CharactersQuery
    private var handler: Handler<CharactersPage>
    private var cancellable: AnyCancellable?

    // MARK: - Initializer
    init(query: CharactersQuery,
         charactersGateway: CharactersGateway,
         handler: @escaping Handler<CharactersPage>) {
        self.charactersGateway = charactersGateway
        self.handler = handler
        self.query = query
    }
}

extension SearchCharactersUseCase: UseCase {
    func execute() {
        cancellable = charactersGateway.fetchCharacters(with: query)
            .sink { [weak self] completion in
                if case let .failure(netError) = completion {
                    if netError == .noResults {
                        self?.handler(.failure(CharactersGatewayError.noResults))
                    } else {
                        self?.handler(.failure(CharactersGatewayError.networkError))
                    }
                }
            } receiveValue: { [weak self] characterPage in
                let response = characterPage
                self?.handler(.success(response))
            }
    }
}
