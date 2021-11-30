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
                return promise(.success(response.toDomain()))
            }

            self?.cancellable = self?.network
                .getCharacters(with: requestDTO)
                .sink(receiveCompletion: fetchCompletionHandler,
                      receiveValue: fetchValueHandler)
        }
        .eraseToAnyPublisher()
    }

}
