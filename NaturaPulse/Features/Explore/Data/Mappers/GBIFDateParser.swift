//
//  GBIFDateParser.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

enum GBIFDateParser {
    private static let isoWithZone: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        
        return f
    }()

    private static let noZoneFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        return f
    }()

    private static let noZoneSecondsFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return f
    }()

    private static let dateOnlyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd"
        
        return f
    }()

    static func date(from string: String?) -> Date? {
        guard let string, !string.isEmpty else { return nil }
        if let date = isoWithZone.date(from: string) { return date }
        if let date = noZoneSecondsFormatter.date(from: string) { return date }
        if let date = noZoneFormatter.date(from: string) { return date }
        if let date = dateOnlyFormatter.date(from: string) { return date }
        return nil
    }
}
