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
    private var handler: Handler<CharactersPage>
    private var cancellable: AnyCancellable?

    // MARK: - Initializer
    init(charactersGateway: CharactersGateway, handler: @escaping Handler<CharactersPage>) {
        self.charactersGateway = charactersGateway
        self.handler = handler
    }
}

extension SearchCharactersUseCase: UseCase {
    func execute() {
        cancellable = charactersGateway.fetchCharacters()
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.handler(.failure(CharactersGatewayError.noResults))
                }
            } receiveValue: { [weak self] characterPage in
                let response = characterPage
                self?.handler(.success(response))

            }
    }

}
