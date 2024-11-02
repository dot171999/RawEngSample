//
//  StringExtensions.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import Foundation

extension String {
    func toReadableDateFormatFromISO8601(_ dateFormat: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
        
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = dateFormat
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date).uppercased()
    }
    
    func toDateFromISO8601() -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
        
        return isoFormatter.date(from: self)
    }
}
