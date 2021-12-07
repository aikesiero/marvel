//
//  MockedAPINetwork.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import XCTest
import Combine
@testable import Marvel

// MARK: - APINetwork

class TestNetworkManager: APINetwork {

    init() {
        super.init(baseURL: "https://test.com",
                   publicKey: "",
                   privateKey: "")
        self.session = .mockedResponsesOnly
    }
}

final class MockedAPINetwork: TestNetworkManager, Mock {

    enum Action: Equatable {
        case getCharacters
        case getCharacter(Int)
    }
    var actions = MockActions<Action>(expected: [])

    var charactersResponse: Result<CharactersResponseDTO, Error> = .failure(MockError.valueNotFound)
    var characterResponse: Result<CharactersResponseDTO, Error> = .failure(MockError.valueNotFound)

    override func getCharacters(with request: CharactersRequestDTO) -> AnyPublisher<CharactersResponseDTO, Error> {
        register(.getCharacters)
        return characterResponse.publish()
    }

    override func getCharacter(with id: Int) -> AnyPublisher<CharactersResponseDTO, Error> {
        register(.getCharacter(id))
        return characterResponse.publish()
    }
}
