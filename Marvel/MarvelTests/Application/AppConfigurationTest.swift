//
//  AppConfigurationTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 25/11/21.
//

import XCTest
@testable import Marvel

class AppConfigurationTest: XCTestCase {

    var sut: AppConfiguration!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AppConfiguration()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_publicKeyIsGetted() throws {
        var apiKey: String?
        apiKey = sut.apiPublicKey
        XCTAssertNotNil(apiKey)
    }

    func test_privateKeyIsGetted() throws {
        var apiKey: String?
        apiKey = sut.apiPrivateKey
        XCTAssertNotNil(apiKey)
    }

    func test_baseURLIsGetted() throws {
        var baseURL: String?
        baseURL = sut.apiBaseURL
        XCTAssertNotNil(baseURL)
    }

}
