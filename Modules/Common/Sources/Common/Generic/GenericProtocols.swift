//
//  GenericProtocols.swift
//  Common
//
//  Created by Ridwan Febnur AR on 13/09/26.
//

import Combine

public protocol UseCase {
    associatedtype Request
    associatedtype Response
    func execute(_ request: Request) -> AnyPublisher<Response, AppError>
}

public protocol Repository {
    associatedtype Request
    associatedtype Response
    func fetch(_ request: Request) -> AnyPublisher<Response, AppError>
}

public protocol RemoteSource {
    associatedtype Request
    associatedtype Response
    func execute(_ request: Request) -> AnyPublisher<Response, AppError>
}

public protocol Mapper {
    associatedtype DTO
    associatedtype Domain
    func toDomain(_ dto: DTO) -> Domain
}

public struct Interactor<Request, Response, R: Repository>: UseCase
where R.Request == Request, R.Response == Response {
    private let repository: R

    public init(repository: R) {
        self.repository = repository
    }

    public func execute(_ request: Request) -> AnyPublisher<Response, AppError> {
        repository.fetch(request)
    }
}
