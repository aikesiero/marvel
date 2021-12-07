//
//  CharacterDetailViewControllerTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 7/12/21.
//

import XCTest
@testable import Marvel

class CharacterDetailViewControllerTest: XCTestCase {

    // MARK: - Test variables.
    var sut: CharacterDetailViewController!
    var viewModel: CharacterDetailViewModel!
    var useCaseFactory: UseCaseFactoryMock!

    override func setUp() {
        super.setUp()
        useCaseFactory = UseCaseFactoryMock(charactersGateway: CharactersGatewayDummy() )
        viewModel = CharacterDetailViewModel(charactersUseCaseFactory: useCaseFactory, idCharacter: 0)
        sut = CharacterDetailViewController.create(with: viewModel)
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

    func testViewDidLoadSetUpView() {
        sut.viewDidLoad()
        XCTAssertNotNil(sut.title)
    }

    // MARK: - Test doubles
    class UseCaseFactoryMock: CharactersUseCaseFactory {

    }
}
