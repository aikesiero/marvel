//
//  CharactersRepositoryTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 7/12/21.
//

import XCTest
import Combine
@testable import Marvel

class CharactersRepositoryTest: XCTestCase {

    // MARK: - Test variables.
    var sut: CharactersRepository!

    // MARK: - Set up and tear down
    override func setUpWithError() throws {
        super.setUp()
        sut = CharactersRepository(network: MockedAPINetwork(),
                                   cacheResponse: CharactersResponseStorageDummy(),
                                   cacheCharacter: CharacterDetailStorageDummy())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    // MARK: - Basic test.

    func testSutIsntNil() {
        XCTAssertNotNil(sut)
    }
}
