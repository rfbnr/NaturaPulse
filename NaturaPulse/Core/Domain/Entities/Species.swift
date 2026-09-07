import Foundation

struct Species: Identifiable, Equatable {
    let id: Int
    let scientificName: String
    let commonName: String?
    let kingdom: String?
    let phylum: String?
    let className: String?
    let order: String?
    let family: String?
    let genus: String?
    let description: String?
    let image: SpeciesImage?
    let localObservationCount: Int
    let lastObservedAt: Date?
    let source: ObservationSource?
}
