//
//  CharacterListViewControllerTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 7/12/21.
//

import XCTest
@testable import Marvel

class CharactersListViewControllerTest: XCTestCase {

    // MARK: - Test variables.
    var sut: CharactersListViewController!
    var viewModel: CharactersListViewModel!
    var useCaseFactory: UseCaseFactoryMock!
    var flowCoordinator: FlowCoordinatorMock!

    override func setUp() {
        super.setUp()
        useCaseFactory = UseCaseFactoryMock(charactersGateway: CharactersGatewayDummy() )
        flowCoordinator = FlowCoordinatorMock()
        viewModel = CharactersListViewModel(charactersUseCaseFactory: useCaseFactory,
                                            flowCoordinator: flowCoordinator)
        sut = CharactersListViewController.create(with: viewModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        useCaseFactory = nil
        super.tearDown()
    }

    // MARK: - Basic test.

    func testSutIsntNil() {
        XCTAssertNotNil(sut)
    }

    // MARK: - Test doubles

    class UseCaseFactoryMock: CharactersUseCaseFactory {

    }

    class FlowCoordinatorMock: CharactersListFlowCoordinator {

        private var navigateWasInvoked = 0

        init () {
            let dependencies = CharactersListFlowCoordinator.Dependencies(apiNetwork: MockedAPINetwork(),
                                                       cacheResponse: CharactersResponseStorageDummy(),
                                                       cacheCharacter: CharacterDetailStorageDummy())
            super.init(navigationController: UINavigationController(), dependencies: dependencies)
        }

        override func navigate(to destination: CharactersListNavigationDestination?) {
            navigateWasInvoked += 1
        }

        func verifyNavigateInvoked(file: StaticString = #filePath, line: UInt = #line) {
            XCTAssertEqual(1, navigateWasInvoked, "naviagete() invoked", file: file, line: line)
        }
    }
}
