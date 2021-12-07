//
//  CharactersUseCaseFactoryTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import XCTest
@testable import Marvel

class CharactersUseCaseFactoryTest: XCTestCase {

    // MARK: - Test variables
    var sut: CharactersUseCaseFactory!
    var entityGateway: CharactersGateway!

    // MARK: - Set up and tear down
    override func setUpWithError() throws {
        super.setUp()
        entityGateway = CharactersGatewayDummy()
        sut = CharactersUseCaseFactory(charactersGateway: entityGateway)
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

    func testFactoryCreatesSearchCharactersUseCase() {
        let useCase = sut.fetchCharactersUseCase(query: CharactersQuery(), handler: {_ in})
        XCTAssertNotNil(useCase as? SearchCharactersUseCase)
    }

    func testFactoryCreatesGetCharacterUseCase() {
        let useCase = sut.fetchCharacterUseCase(id: 0, handler: {_ in})
        XCTAssertNotNil(useCase as? GetCharacterUseCase)
    }
}
