//
//  SpeciesProfileMapper.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

enum SpeciesProfileMapper {
    static func map(
        _ dto: GBIFDescriptionsResponseDTO
    ) -> SpeciesProfile {
        let usable = dto.results.first { item in
            guard let text = item.description?.trimmingCharacters(in: .whitespacesAndNewlines) else { return false }
            return !text.isEmpty
        }
        
        let summary = usable?.description?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return SpeciesProfile(summary: summary, summarySource: usable?.source)
    }
}
