//
//  GBIFDescriptionsResponseDTO.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct GBIFDescriptionsResponseDTO: Decodable, Equatable {
    let results: [GBIFDescriptionDTO]
}

struct GBIFDescriptionDTO: Decodable, Equatable {
    let type: String?
    let language: String?
    let description: String?
    let source: String?
}
