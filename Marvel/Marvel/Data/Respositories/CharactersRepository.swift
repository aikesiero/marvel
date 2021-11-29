//
//  CharactersRepository.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Foundation
import Combine

final class CharactersRepository {

    private var network: APINetwork
    private var cancellable: AnyCancellable?

    init(network: APINetwork) {
        self.network = network
    }
}

extension CharactersRepository: CharactersGateway {

    func fetchCharacters() -> AnyPublisher<CharactersPage, CharactersGatewayError> {
        Future<CharactersPage, CharactersGatewayError> { [weak self] promise in
             let fetchCompletionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
                switch completion {
                case .failure:
                    print("failure")
                    return promise(.failure(.noResults))
                    // self?.state = .error(.playersFetch)
                case .finished:
                    print("finished")
                }
            }

            let fetchValueHandler: (CharactersResponseDTO) -> Void = { characters in
                print("*******************")
                print(characters)
                return promise(.success(characters.toDomain()))
            }

            self?.cancellable = self?.network
                .getCharacters()
                .sink(receiveCompletion: fetchCompletionHandler,
                      receiveValue: fetchValueHandler)
        }
        .eraseToAnyPublisher()
    }

    func fetchCharacters(with query: String) -> AnyPublisher<CharactersPage, CharactersGatewayError> {
        // TODO: provisional
        Future<CharactersPage, CharactersGatewayError> { [weak self] promise in
             let fetchCompletionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
                switch completion {
                case .failure:
                    print("failure")
                    return promise(.failure(.noResults))
                    // self?.state = .error(.playersFetch)
                case .finished:
                    print("finished")
                }
            }

            let fetchValueHandler: (CharactersResponseDTO) -> Void = { characters in
                print("*******************")
                print(characters)
                return promise(.success(characters.toDomain()))
            }

            self?.cancellable = self?.network
                .getCharacters()
                .sink(receiveCompletion: fetchCompletionHandler,
                      receiveValue: fetchValueHandler)
        }
        .eraseToAnyPublisher()
    }

}
