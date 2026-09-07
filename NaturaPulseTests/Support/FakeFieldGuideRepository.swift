import Combine
@testable import NaturaPulse

final class FakeFieldGuideRepository: FieldGuideRepository {
    var savedResult: Result<[Species], AppError> = .success([])

    func savedSpecies() -> AnyPublisher<[Species], AppError> {
        savedResult.publisher.eraseToAnyPublisher()
    }

    func isSaved(_ id: Species.ID) -> AnyPublisher<Bool, Never> {
        Just(false).eraseToAnyPublisher()
    }

    func save(_ species: Species) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func remove(id: Species.ID) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}
