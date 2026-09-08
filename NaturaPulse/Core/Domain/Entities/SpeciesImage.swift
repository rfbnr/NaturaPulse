//
//  SpeciesImage.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct SpeciesImage: Equatable, Hashable {
    let url: URL
    let creator: String?
    let license: String?
    let sourceURL: URL?
}
