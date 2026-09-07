//
//  GBIFMediaDTO.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct GBIFMediaDTO: Decodable, Equatable {
    let type: String?
    let format: String?
    let identifier: String?
    let creator: String?
    let license: String?
    let references: String?
    let publisher: String?
    let rightsHolder: String?
}
