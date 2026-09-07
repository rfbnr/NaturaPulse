import XCTest
import Combine
@testable import NaturaPulse

extension XCTestCase {
    /// Awaits a single value (or failure) from a publisher whose Failure is AppError-like.
    func awaitPublisher<P: Publisher>(
        _ publisher: P,
        timeout: TimeInterval = 2,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> P.Output {
        var result: Result<P.Output, Error>?
        let expectation = expectation(description: "awaitPublisher")
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    result = .failure(error)
                }
                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
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
