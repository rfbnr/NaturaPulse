//
//  CombineTestHelpers.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import Combine
@testable import NaturaPulse

extension XCTestCase {
    func awaitPublisher<P: Publisher>(
        _ publisher: P,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> P.Output {
        var result: Result<P.Output, Error>?
        var didFulfill = false
        let expectation = expectation(description: "awaitPublisher")
        let fulfillOnce = {
            guard !didFulfill else { return }
            didFulfill = true
            expectation.fulfill()
        }
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    result = .failure(error)
                }
                fulfillOnce()
            },
            receiveValue: { value in
                result = .success(value)
                fulfillOnce()
            }
        )
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        switch result {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        case .none:
            XCTFail("Publisher completed with no value", file: file, line: line)
            throw AppError.unknown
        }
    }
}
