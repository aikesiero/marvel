//
//  GetCharacterUseCase.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 1/12/21.
//

import Combine

final class GetCharacterUseCase {

    // MARK: - Properties
    private let charactersGateway: CharactersGateway
    private let id: Int
    private var handler: Handler<Character>
    private var cancellable: AnyCancellable?

    // MARK: - Initializer
    init(id: Int,
         charactersGateway: CharactersGateway,
         handler: @escaping Handler<Character>) {
        self.charactersGateway = charactersGateway
        self.handler = handler
        self.id = id
    }
}

extension GetCharacterUseCase: UseCase {
    func execute() {
        cancellable = charactersGateway.fetchCharacter(with: id)
            .sink { [weak self] completion in
                if case let .failure(netError) = completion {
                    if netError == .noResults {
                        self?.handler(.failure(CharactersGatewayError.noResults))
                    } else {
                        self?.handler(.failure(CharactersGatewayError.networkError))
                    }
                }
            } receiveValue: { [weak self] character in
                self?.handler(.success(character))
            }
    }
}
