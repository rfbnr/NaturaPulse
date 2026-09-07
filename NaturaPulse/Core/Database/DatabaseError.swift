//
//  DatabaseError.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

enum DatabaseError: Error, Equatable {
    case writeFailed
    case readFailed
    case notFound
    case underlying(String)
}
