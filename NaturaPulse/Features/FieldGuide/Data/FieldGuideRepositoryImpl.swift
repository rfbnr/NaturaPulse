//
//  FieldGuideRepositoryImpl.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation
import Realm
import RealmSwift

final class FieldGuideRepositoryImpl: FieldGuideRepository {
    private let realmProvider: RealmProvider

    init(realmProvider: RealmProvider) {
        self.realmProvider = realmProvider
    }

    func savedSpecies() -> AnyPublisher<[Species], AppError> {
        do {
            let realm = try realmProvider.realm()
            let results = realm.objects(SavedSpeciesObject.self).sorted(byKeyPath: "savedAt", ascending: false)
            // NOTE: RealmSwift's `collectionPublisher` does not deliver notifications reliably in the
            // linked Realm build, so we bridge the raw NotificationToken API into a CurrentValueSubject.
            // The subject is seeded synchronously with the current snapshot (so the first emission is
            // available immediately, without waiting on the notification run loop), and is subsequently
            // updated whenever Realm reports a change. Only value types (`[Species]`) ever leave this
            // method — the thread-confined `Results`/`Object` stay inside the observation closure.
            let subject = CurrentValueSubject<[Species], AppError>(results.map(SavedSpeciesMapper.domain(from:)))
            var token: NotificationToken?
            token = results.observe { change in
                switch change {
                case let .initial(collection):
                    subject.send(collection.map(SavedSpeciesMapper.domain(from:)))
                case let .update(collection, _, _, _):
                    subject.send(collection.map(SavedSpeciesMapper.domain(from:)))
                case .error:
                    // The stream is terminating via completion (not cancellation), so
                    // `handleEvents(receiveCancel:)` below will not fire — invalidate here
                    // to avoid leaking the NotificationToken and its captured subject.
                    token?.invalidate()
                    subject.send(completion: .failure(.persistence))
                }
            }
            return subject
                .removeDuplicates()
                .handleEvents(receiveCancel: { token?.invalidate() })
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: AppError.persistence).eraseToAnyPublisher()
        }
    }

    func isSaved(_ id: Species.ID) -> AnyPublisher<Bool, Never> {
        do {
            let realm = try realmProvider.realm()
            let results = realm.objects(SavedSpeciesObject.self)
            // See `savedSpecies()` for why we bridge the raw NotificationToken API here instead of
            // using `collectionPublisher`.
            let subject = CurrentValueSubject<Bool, Never>(results.contains { $0.id == id })
            let token = results.observe { change in
                switch change {
                case let .initial(collection):
                    subject.send(collection.contains { $0.id == id })
                case let .update(collection, _, _, _):
                    subject.send(collection.contains { $0.id == id })
                case .error:
                    subject.send(false)
                }
            }
            return subject
                .handleEvents(receiveCancel: { token.invalidate() })
                .eraseToAnyPublisher()
        } catch {
            return Just(false).eraseToAnyPublisher()
        }
    }

    func save(_ species: Species) -> AnyPublisher<Void, AppError> {
        do {
            let realm = try realmProvider.realm()
            try realm.write {
                realm.add(SavedSpeciesMapper.object(from: species, savedAt: Date()), update: .modified)
            }
            return Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: AppError.persistence).eraseToAnyPublisher()
        }
    }

    func remove(id: Species.ID) -> AnyPublisher<Void, AppError> {
        do {
            let realm = try realmProvider.realm()
            try realm.write {
                if let object = realm.object(ofType: SavedSpeciesObject.self, forPrimaryKey: id) {
                    realm.delete(object)
                }
            }
            return Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
        } catch {
            return Fail(error: AppError.persistence).eraseToAnyPublisher()
        }
    }
}
