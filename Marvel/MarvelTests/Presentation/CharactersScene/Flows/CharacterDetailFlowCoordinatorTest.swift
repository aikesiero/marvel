//
//  CharacterDetailFlowCoordinatorTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 7/12/21.
//

import XCTest
@testable import Marvel

class CharacterDetailFlowCoordinatorTest: XCTestCase {

    // MARK: - Test variables.
    var sut: CharacterDetailFlowCoordinator!
    var navigationController: SpyNavigationController!
    var destination: CharactersListNavigationDestination?

    override func setUp() {
        super.setUp()
        navigationController = SpyNavigationController(rootViewController: UIViewController())
        let dependencies = CharacterDetailFlowCoordinator.Dependencies(apiNetwork: MockedAPINetwork(),
                                                   cacheResponse: CharactersResponseStorageDummy(),
                                                   cacheCharacter: CharacterDetailStorageDummy())
        sut = CharacterDetailFlowCoordinator(navigationController: navigationController,
                                             dependencies: dependencies,
                                             idCharacter: 0)
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    // MARK: - Basic test.

    func testSutIsntNil() {
        XCTAssertNotNil(sut)
    }

    func testStartGenerateNavigation() {
        sut.start()
        guard (navigationController.pushedViewController as? CharacterDetailViewController) != nil else {
            XCTFail("CharacterDetailViewController not reached")
            return
        }
        XCTAssertNotNil(navigationController.pushedViewController)
    }
}
