import XCTest
import Combine
@testable import NaturaPulse

final class GetSavedSpeciesUseCaseTests: XCTestCase {

    func testReturnsSavedSpeciesWhenRepositorySucceeds() throws {
        let expected = [Species.stub(id: 1), Species.stub(id: 2)]
        let repository = FakeFieldGuideRepository()
        repository.savedResult = .success(expected)
        let useCase = GetSavedSpeciesUseCase(repository: repository)

        let result = try awaitPublisher(useCase())

        XCTAssertEqual(result, expected)
    }

    func testPropagatesErrorWhenRepositoryFails() {
        let repository = FakeFieldGuideRepository()
        repository.savedResult = .failure(.persistence)
        let useCase = GetSavedSpeciesUseCase(repository: repository)

        XCTAssertThrowsError(try awaitPublisher(useCase())) { error in
            XCTAssertEqual(error as? AppError, .persistence)
        }
    }
}
