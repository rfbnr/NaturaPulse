//
//  SearchOutcome.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

enum SearchOutcome: Equatable {
    case idle
    case loading
    case result([Species])
    case failure(AppError)
}
