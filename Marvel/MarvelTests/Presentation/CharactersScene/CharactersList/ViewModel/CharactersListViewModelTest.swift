//
//  CharactersListViewModelTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import XCTest
@testable import Marvel

class CharactersListViewModelTest: XCTestCase {

    // MARK: - Test variables.
    var sut: CharactersListViewModel!
    var useCaseFactory: UseCaseFactoryMock!
    var flowCoordinator: FlowCoordinatorMock!

    override func setUp() {
        super.setUp()
        useCaseFactory = UseCaseFactoryMock(charactersGateway: CharactersGatewayDummy() )
        flowCoordinator = FlowCoordinatorMock()
        sut = CharactersListViewModel(charactersUseCaseFactory: useCaseFactory,
                                      flowCoordinator: flowCoordinator)
    }

    override func tearDownWithError() throws {
        sut = nil
        useCaseFactory = nil
        super.tearDown()
    }

    // MARK: - Basic test.

    func testSutIsntNil() {
        XCTAssertNotNil(sut)
    }

    func testViewReadyInvokesUseCase() {
        sut.viewDidLoad()
        useCaseFactory.fetchCharactersUseCase.verifyExecuteInvoked()
    }

    func testFailsNoResultsInvokesUseCase() {
        useCaseFactory.useCaseError = CharactersGatewayError.noResults
        sut.viewDidLoad()
        useCaseFactory.fetchCharactersUseCase.verifyExecuteInvoked()
    }

    func testFailsOtherGatewayErrorInvokesUseCase() {
        useCaseFactory.useCaseError = CharactersGatewayError.networkError
        sut.viewDidLoad()
        useCaseFactory.fetchCharactersUseCase.verifyExecuteInvoked()
    }

    func testDidSearchInvokesUseCase() {
        sut.didSearch(query: "")
        useCaseFactory.fetchCharactersUseCase.verifyExecuteInvoked()
    }

    func testDidSelectCharacterInvokesNavigation() {
        let character = Character.main()
        sut.characters = [CharactersListItemViewModel(character: character)]
        sut.didSelectCharacter(at: 0)
        flowCoordinator.verifyNavigateInvoked()
    }

    func testDidLoadNextPage() {
        sut.viewDidLoad()
        var actualPage = useCaseFactory.actualPage
        let nextPage = sut.nextPage
        sut.didLoadNextPage()
        actualPage = useCaseFactory.actualPage
        XCTAssertEqual(actualPage, nextPage)
    }

    func testDidCancelSearch() {
        sut.viewDidLoad()
        let originalPage = useCaseFactory.actualPage
        var actualPage = useCaseFactory.actualPage
        let nextPage = sut.nextPage
        sut.didLoadNextPage()
        sut.didCancelSearch()
        sut.viewDidLoad()
        actualPage = useCaseFactory.actualPage
        XCTAssertNotEqual(actualPage, nextPage)
        XCTAssertEqual(originalPage, actualPage)
    }

    // MARK: - Test doubles
    class UseCaseFactoryMock: CharactersUseCaseFactory {

        var fetchCharactersUseCase: FetchCharactersUseCaseMock!
        var characters: CharactersPage = CharactersPage.main()
        var character: Character = Character.main()
        var actualPage: Int = 0
        var useCaseError: CharactersGatewayError?

        override func fetchCharactersUseCase(query: CharactersQuery,
                                             handler: @escaping Handler<CharactersPage>) -> UseCase {
            fetchCharactersUseCase = FetchCharactersUseCaseMock(handler: handler,
                                                               response: characters)
            fetchCharactersUseCase.useCaseError = useCaseError
            actualPage = query.page
            return fetchCharactersUseCase
        }
    }

    class FetchCharactersUseCaseMock: UseCase {
        private var executeWasInvoked = 0
        private var handler: Handler<CharactersPage>
        var response: CharactersPage
        var useCaseError: CharactersGatewayError?

        init(handler: @escaping Handler<CharactersPage>, response: CharactersPage) {
            self.handler = handler
            self.response = response
        }

        func execute() {
            executeWasInvoked += 1

            guard let error = useCaseError else {
                handler(.success(response))
                return
            }
            handler(.failure(error))
        }

        func verifyExecuteInvoked(file: StaticString = #filePath, line: UInt = #line) {
            XCTAssertEqual(1, executeWasInvoked, "execute() invoked", file: file, line: line)
        }
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
