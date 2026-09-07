import Foundation

struct Distance: Equatable {
    let kilometers: Double

    static func km(_ value: Double) -> Distance {
        Distance(kilometers: value)
    }
}
