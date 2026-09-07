//
//  SpeciesMapper.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

enum SpeciesMapper {
    static func map(_ dtos: [GBIFOccurrenceDTO]) -> [Species] {
        // Group occurrences into unique species, preserving first-seen order.
        var order: [Int] = []
        var groups: [Int: [GBIFOccurrenceDTO]] = [:]
        for dto in dtos {
            let groupKey = dto.speciesKey ?? dto.taxonKey ?? dto.key
            if groups[groupKey] == nil { order.append(groupKey) }
            groups[groupKey, default: []].append(dto)
        }

        return order.compactMap { groupKey in
            guard let occurrences = groups[groupKey], let representative = occurrences.first else { return nil }
            let withImage = occurrences.first { usableImage(from: $0) != nil }
            let imageSource = withImage ?? representative
            let lastObserved = occurrences
                .compactMap { GBIFDateParser.date(from: $0.eventDate) }
                .max()
            return Species(
                id: groupKey,
                scientificName: representative.scientificName ?? "Unknown species",
                commonName: representative.vernacularName,
                kingdom: representative.kingdom,
                phylum: representative.phylum,
                className: representative.className,
                order: representative.order,
                family: representative.family,
                genus: representative.genus,
                description: nil,
                image: usableImage(from: imageSource),
                localObservationCount: occurrences.count,
                lastObservedAt: lastObserved,
                source: source(from: representative)
            )
        }
    }

    private static func usableImage(from dto: GBIFOccurrenceDTO) -> SpeciesImage? {
        guard let media = dto.media else { return nil }
        for item in media {
            guard let identifier = item.identifier, let url = URL(string: identifier) else { continue }
            return SpeciesImage(
                url: url,
                creator: item.creator,
                license: item.license,
                sourceURL: item.references.flatMap(URL.init(string:))
            )
        }
        return nil
    }

    private static func source(from dto: GBIFOccurrenceDTO) -> ObservationSource? {
        guard dto.datasetName != nil else { return nil }
        return ObservationSource(datasetName: dto.datasetName, publisher: nil, referenceURL: nil)
    }
}
