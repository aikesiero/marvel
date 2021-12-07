//
//  GetCharacterUseCaseTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import XCTest
import Combine
@testable import Marvel

class GetCharacterUseCaseTest: XCTestCase {

    // MARK: - Test variables
    var sut: GetCharacterUseCase!
    var entityGateway: CharacterGatewayMock!
    var response: Character = Character.alt()
    var error: Error?

    // MARK: - Set up and tear down
    override func setUpWithError() throws {
        super.setUp()
        entityGateway = CharacterGatewayMock()
        sut = GetCharacterUseCase(id: 0,
                                  charactersGateway: entityGateway) { [weak self] result in
            switch result {
            case let .success(character):
                self?.response = character
            case let .failure(error):
                self?.error = error
            }
        }
    }

    override func tearDownWithError() throws {
        sut = nil
        entityGateway = nil
        super.tearDown()
    }

    // MARK: - Basic test
    func testSutIsntNil() {
        XCTAssertNotNil(sut)
    }

    func testTransformsCharactersEntityIntoReponse() {
        entityGateway.character = Character.main()
        let expected = Character.main()
        sut.execute()
        XCTAssertEqual(expected, response)
    }

    func testReportsErrorFromNoResults() {
        entityGateway.error = CharactersGatewayError.noResults
        sut.execute()
        XCTAssertNotNil(self.error)
    }

    func testReportsErrorFromNetworkError() {
        entityGateway.error = CharactersGatewayError.networkError
        sut.execute()
        XCTAssertNotNil(self.error)
    }

    // MARK: - Test Doubles
    class CharacterGatewayMock: CharactersGatewayDummy {
        var character: Character = Character.main()
        var error: CharactersGatewayError?

        override func fetchCharacter(with id: Int) -> AnyPublisher<Character, CharactersGatewayError> {
            guard let charactersError = error else {
                return Just(character).setFailureType(to: CharactersGatewayError.self).eraseToAnyPublisher()
            }
            return Fail(error: charactersError).eraseToAnyPublisher()
        }
    }
}
