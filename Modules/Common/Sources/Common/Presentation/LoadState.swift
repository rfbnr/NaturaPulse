//
//  LoadState.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

public enum LoadState<Value: Equatable>: Equatable {
    case idle
    case loading(previous: Value?)
    case loaded(Value)
    case empty
    case failed(AppError)
}
