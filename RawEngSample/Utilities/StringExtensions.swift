//
//  StringExtensions.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 25/10/24.
//

import Foundation

extension String {
    
    func toReadableDateFromISO8601() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
        
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEE MMM dd"
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date).uppercased()
    }
    
    func toReadableTimeFromISO8601() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions.insert(.withFractionalSeconds)
        
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        outputFormatter.timeZone = TimeZone.current
        
        return outputFormatter.string(from: date).uppercased()
    }
}
