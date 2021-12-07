//
//  SearchCharactersUseCase.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import XCTest
import Combine
@testable import Marvel

class SearchCharactersUseCaseTest: XCTestCase {

    // MARK: - Test variables
    var sut: SearchCharactersUseCase!
    var entityGateway: CharacterGatewayMock!
    var response: CharactersPage = CharactersPage.alt()
    var error: Error?

    // MARK: - Set up and tear down
    override func setUpWithError() throws {
        super.setUp()
        entityGateway = CharacterGatewayMock()
        sut = SearchCharactersUseCase(query: CharactersQuery(),
                                      charactersGateway: entityGateway) { [weak self] result in
            switch result {
            case let .success(characters):
                self?.response = characters
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

    func testRepoWithNoCharactersGeneratesNoCharactesResponses() {
        entityGateway.characters = CharactersPage(page: 0, totalPages: 0, characters: [])
        sut.execute()
        XCTAssertEqual(0, response.characters.count, "CharactersResponses")
    }

    func testTransformsCharactersEntityIntoReponse() {
        entityGateway.characters = CharactersPage.main()
        let expected = CharactersPage.main()
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
        var characters: CharactersPage = CharactersPage.main()
        var error: CharactersGatewayError?

        override func fetchCharacters(with query: CharactersQuery)
        -> AnyPublisher<CharactersPage, CharactersGatewayError> {

            guard let charactersError = error else {
                return Just(characters).setFailureType(to: CharactersGatewayError.self).eraseToAnyPublisher()
            }
            return Fail(error: charactersError).eraseToAnyPublisher()

        }
    }
}
