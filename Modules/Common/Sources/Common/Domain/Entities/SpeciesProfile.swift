//
//  SpeciesProfile.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

public struct SpeciesProfile: Equatable {
    public let summary: String?
    public let summarySource: String?

    public init(summary: String?, summarySource: String?) {
        self.summary = summary
        self.summarySource = summarySource
    }
}
