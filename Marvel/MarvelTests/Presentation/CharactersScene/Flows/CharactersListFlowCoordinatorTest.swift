//
//  CharactersListFlowCoordinatorTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import XCTest
@testable import Marvel

class CharactersListFlowCoordinatorTest: XCTestCase {

    // MARK: - Test variables.
    var sut: CharactersListFlowCoordinator!
    var navigationController: SpyNavigationController!
    var destination: CharactersListNavigationDestination?

    override func setUp() {
        super.setUp()
        navigationController = SpyNavigationController(rootViewController: UIViewController())
        let dependencies = CharactersListFlowCoordinator.Dependencies(apiNetwork: MockedAPINetwork(),
                                                   cacheResponse: CharactersResponseStorageDummy(),
                                                   cacheCharacter: CharacterDetailStorageDummy())
        sut = CharactersListFlowCoordinator(navigationController: navigationController,
                                            dependencies: dependencies)
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
        guard (navigationController.pushedViewController as? CharactersListViewController) != nil else {
            XCTFail("CharacterListViewController not reached")
            return
        }
    }

    func testSelectedNavigationIsPerformed() {
        sut.start()
        sut.navigate(to: .detail(0))
        guard (navigationController.pushedViewController as? CharacterDetailViewController) != nil else {
            XCTFail("CharacterDetailViewController not reached")
            return
        }
    }

    func testNotSelectedNavigationNotPerfomNavigation() {
        sut.start()
        sut.navigate(to: .none)
        guard (navigationController.pushedViewController as? CharactersListViewController) != nil else {
            XCTFail("CharacterListViewController not reached")
            return
        }
    }

}
