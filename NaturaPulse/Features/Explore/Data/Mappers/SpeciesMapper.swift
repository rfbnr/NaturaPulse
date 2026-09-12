//
//  SpeciesMapper.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

enum SpeciesMapper {
    static func map(
        _ dtos: [GBIFOccurrenceDTO]
    ) -> [Species] {
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
            let coordinate: Coordinate? = {
                guard let lat = representative.decimalLatitude, let lon = representative.decimalLongitude else { return nil }
                return Coordinate(latitude: lat, longitude: lon)
            }()
            
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
                source: source(from: representative),
                coordinate: coordinate
            )
        }
    }

    private static func usableImage(
        from dto: GBIFOccurrenceDTO
    ) -> SpeciesImage? {
        guard let media = dto.media else { return nil }
        
        let candidates = media.compactMap { item -> (item: GBIFMediaDTO, url: URL)? in
            guard let identifier = item.identifier, let url = httpsUpgraded(identifier) else { return nil }
            return (item, url)
        }
        
        let preferred = candidates.first { $0.item.type == "StillImage" } ?? candidates.first
        guard let match = preferred else { return nil }
        
        return SpeciesImage(
            url: match.url,
            creator: match.item.creator,
            license: match.item.license,
            sourceURL: match.item.references.flatMap(URL.init(string:))
        )
    }

    private static func httpsUpgraded(_ identifier: String) -> URL? {
        guard let url = URL(string: identifier) else { return nil }
        guard url.scheme?.lowercased() == "http",
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        components.scheme = "https"
        return components.url ?? url
    }

    private static func source(
        from dto: GBIFOccurrenceDTO
    ) -> ObservationSource? {
        guard dto.datasetName != nil else { return nil }
        
        return ObservationSource(datasetName: dto.datasetName, publisher: nil, referenceURL: nil)
    }
}
