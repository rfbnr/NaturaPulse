import XCTest
@testable import NaturaPulse

final class DomainFoundationTests: XCTestCase {

    func testSpeciesEquatableComparesAllFields() {
        let date = Date(timeIntervalSince1970: 0)
        let a = Species.stub(id: 1, scientificName: "Copsychus saularis", lastObservedAt: date)
        let b = Species.stub(id: 1, scientificName: "Copsychus saularis", lastObservedAt: date)
        let c = Species.stub(id: 2, scientificName: "Acridotheres tristis", lastObservedAt: date)

        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
    }

    func testAppErrorIsEquatable() {
        XCTAssertEqual(AppError.persistence, AppError.persistence)
        XCTAssertNotEqual(AppError.persistence, AppError.networkUnavailable)
    }

    func testDistanceKilometersFactory() {
        XCTAssertEqual(Distance.km(10), Distance(kilometers: 10))
    }
}
