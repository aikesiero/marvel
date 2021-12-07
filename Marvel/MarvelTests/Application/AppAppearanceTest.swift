//
//  AppAppeareanceTest.swift
//  MarvelTests
//
//  Created by Aike Fernández Roza on 6/12/21.
//

import XCTest
@testable import Marvel

class AppAppearanceTest: XCTestCase {

    // MARK: - Basic test
    func testAppearance() {
        // Given
        let expectedResult: UIColor =  .mainColor ?? .black
        var result: UIColor =  .white
        // When
        AppAppearance.setupAppearance()
        result = UINavigationBar.appearance().standardAppearance.backgroundColor ?? .white
        // Then
        XCTAssertEqual(expectedResult, result)
    }
}
