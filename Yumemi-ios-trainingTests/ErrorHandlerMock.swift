//
//  ErrorHandlerMock.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/09/13.
//

import XCTest
@testable import Yumemi_ios_training

extension ErrorHandler {
    static let fulfillXCTestExpectation = Self(
        handle: { _, _ in
            let expectation = Expectation.fetchFailed
            expectation.fulfill()
        }
    )
}
