import Combine

protocol WeatherRepository {
    func context(at location: Location) -> AnyPublisher<WeatherContext, AppError>
}
