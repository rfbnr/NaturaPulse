//
//  ObservationSource.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

public struct ObservationSource: Equatable, Hashable {
    public let datasetName: String?
    public let publisher: String?
    public let referenceURL: URL?

    public init(datasetName: String?, publisher: String?, referenceURL: URL?) {
        self.datasetName = datasetName
        self.publisher = publisher
        self.referenceURL = referenceURL
    }
}
