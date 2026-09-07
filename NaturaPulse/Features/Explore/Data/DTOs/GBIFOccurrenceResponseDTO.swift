//
//  GBIFOccurrenceResponseDTO.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct GBIFOccurrenceResponseDTO: Decodable, Equatable {
    let count: Int
    let results: [GBIFOccurrenceDTO]
}
