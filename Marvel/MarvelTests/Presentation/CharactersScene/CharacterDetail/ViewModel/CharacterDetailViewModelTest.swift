//
//  CharacterDetailViewModelTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import XCTest
@testable import Marvel

class CharacterDetailViewModelTest: XCTestCase {

    // MARK: - Test variables.
    var sut: CharacterDetailViewModel!
    var useCaseFactory: UseCaseFactoryMock!

    override func setUp() {
        super.setUp()
        useCaseFactory = UseCaseFactoryMock(charactersGateway: CharactersGatewayDummy() )
        sut = CharacterDetailViewModel(charactersUseCaseFactory: useCaseFactory, idCharacter: 0)
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
        useCaseFactory.fetchCharacterUseCase.verifyExecuteInvoked()
    }

    func testFailsNoResultsInvokesUseCase() {
        useCaseFactory.useCaseError = CharactersGatewayError.noResults
        sut.viewDidLoad()
        useCaseFactory.fetchCharacterUseCase.verifyExecuteInvoked()
    }

    func testFailsOtherGatewayErrorInvokesUseCase() {
        useCaseFactory.useCaseError = CharactersGatewayError.networkError
        sut.viewDidLoad()
        useCaseFactory.fetchCharacterUseCase.verifyExecuteInvoked()
    }

    // MARK: - Test doubles
    class UseCaseFactoryMock: CharactersUseCaseFactory {

        var fetchCharacterUseCase: FetchCharacterUseCaseMock!
        var characters: CharactersPage = CharactersPage.main()
        var character: Character = Character.main()
        var actualPage: Int = 0
        var useCaseError: CharactersGatewayError?

        override func fetchCharacterUseCase(id: Int,
                                            handler: @escaping Handler<Character>) -> UseCase {
            fetchCharacterUseCase = FetchCharacterUseCaseMock(handler: handler,
                                                               response: character)
            fetchCharacterUseCase.useCaseError = useCaseError
            return fetchCharacterUseCase
        }
    }

    class FetchCharacterUseCaseMock: UseCase {
        private var executeWasInvoked = 0
        private var handler: Handler<Character>
        var response: Character
        var useCaseError: CharactersGatewayError?

        init(handler: @escaping Handler<Character>, response: Character) {
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

}
