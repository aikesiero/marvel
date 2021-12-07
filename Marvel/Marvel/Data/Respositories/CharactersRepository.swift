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
    private let cacheResponse: CharactersResponseStorage
    private let cacheCharacter: CharacterDetailStorage
    private var cancellable: AnyCancellable?

    init(network: APINetwork,
         cacheResponse: CharactersResponseStorage,
         cacheCharacter: CharacterDetailStorage) {
        self.network = network
        self.cacheResponse = cacheResponse
        self.cacheCharacter = cacheCharacter
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
                self?.cacheResponse.save(response: response, for: requestDTO)
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

            self?.cancellable = self?.cacheResponse.getResponse(for: requestDTO)
                .sink(receiveCompletion: fetchCacheCompletionHandler,
                      receiveValue: fetchValueHandler)

        }
        .eraseToAnyPublisher()
    }

    func fetchCharacter(with id: Int) -> AnyPublisher<Character, CharactersGatewayError> {

        return Future<Character, CharactersGatewayError> { [weak self] promise in

            let fetchCompletionHandler: (Subscribers.Completion<Error>) -> Void = { completion in
                 if case .failure = completion {
                     return promise(.failure(.networkError))
                 }
            }

            let fetchValueHandler: (CharacterDTO) -> Void = { response in
                self?.cacheCharacter.save(character: response)
                return promise(.success(response.toDomain()))
            }

            let fetchResponseHandler: (CharactersResponseDTO) -> Void = { response in
                guard let characterDTO = response.firstElementDTO(),
                      let character = response.firstElement() else {
                    return promise(.failure(.noResults))
                }
                self?.cacheCharacter.save(character: characterDTO)
                return promise(.success(character))
            }

            let fetchCacheCompletionHandler: (Subscribers.Completion<CoreDataStorageError>) -> Void = { completion in
                 if case .failure = completion {
                     self?.cancellable = self?.network
                         .getCharacter(with: id)
                         .sink(receiveCompletion: fetchCompletionHandler,
                               receiveValue: fetchResponseHandler)
                 }
            }

            self?.cancellable = self?.cacheCharacter.getCharacter(for: id)
                .sink(receiveCompletion: fetchCacheCompletionHandler,
                      receiveValue: fetchValueHandler)

        }
        .eraseToAnyPublisher()
    }

}
