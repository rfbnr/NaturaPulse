//
//  SpeciesImage.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

public struct SpeciesImage: Equatable, Hashable {
    public let url: URL
    public let creator: String?
    public let license: String?
    public let sourceURL: URL?

    public init(url: URL, creator: String?, license: String?, sourceURL: URL?) {
        self.url = url
        self.creator = creator
        self.license = license
        self.sourceURL = sourceURL
    }
}
