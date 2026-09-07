import Combine

protocol FieldGuideRepository {
    func savedSpecies() -> AnyPublisher<[Species], AppError>
    func isSaved(_ id: Species.ID) -> AnyPublisher<Bool, Never>
    func save(_ species: Species) -> AnyPublisher<Void, AppError>
    func remove(id: Species.ID) -> AnyPublisher<Void, AppError>
}
