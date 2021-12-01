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
    private let cache: CharactersResponseStorage
    private var cancellable: AnyCancellable?

    init(network: APINetwork, cache: CharactersResponseStorage) {
        self.network = network
        self.cache = cache
    }
}

extension CharactersRepository: CharactersGateway {

    func fetchCharacters(with query: CharactersQuery) -> AnyPublisher<CharactersPage, CharactersGatewayError> {

        let offset = query.pageSize * (query.page - 1)
        let requestDTO = CharactersRequestDTO(query: query.query,
                                              limit: query.pageSize,
                                              offset: offset)

        return Future<CharactersPage, CharactersGatewayError> { [weak self] promise in

            let fetchCompletionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
                 if case .failure = completion {
                     return promise(.failure(.networkError))
                 }
            }

            let fetchValueHandler: (CharactersResponseDTO) -> Void = { response in

                guard response.result.characters.count > 0 else {
                    return promise(.failure(.noResults))
                }
                self?.cache.save(response: response, for: requestDTO)
                return promise(.success(response.toDomain()))
            }

            let fetchCacheCompletionHandler: (Subscribers.Completion<CoreDataStorageError>) -> Void = { completion in
                 if case .failure = completion {
                     self?.cancellable = self?.network
                         .getCharacters(with: requestDTO)
                         .sink(receiveCompletion: fetchCompletionHandler,
                               receiveValue: fetchValueHandler)
                 }
            }

            self?.cancellable = self?.cache.getResponse(for: requestDTO)
                .sink(receiveCompletion: fetchCacheCompletionHandler,
                      receiveValue: fetchValueHandler)

        }
        .eraseToAnyPublisher()
    }

}
