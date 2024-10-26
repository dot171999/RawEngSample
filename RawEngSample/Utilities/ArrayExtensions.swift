//
//  ArrayExtensions.swift
//  RawEngSample
//
//  Created by Aryan Sharma on 26/10/24.
//

import Foundation

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var seen = Set<Element>()
        return self.filter { item in
            if seen.contains(item) {
                return false
            } else {
                seen.insert(item)
                return true
            }
        }
    }
}
