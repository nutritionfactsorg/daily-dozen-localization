//  File: ArrayExtensions.swift
//  AppLocalizerLib

import Foundation

public extension Array where Element == String {
    mutating func sortByKeyParts() {
        self.sort { (str1, str2) -> Bool in
            // Get key parts with lowercase namePart for case-insensitive comparison
            let (name1, index1) = str1.keyParts(lowercased: true)
            let (name2, index2) = str2.keyParts(lowercased: true)
            
            // Primary: Compare lowercase nameParts
            if name1 != name2 {
                return name1 < name2
            }
            
            // Secondary: Compare indexParts when nameParts match
            switch (index1, index2) {
            case (nil, nil):
                // If both have no index, keep original order (stable sort)
                return false
            case (nil, _):
                // Strings without index come before those with index
                return true
            case (_, nil):
                // Strings with index come after those without
                return false
            case (let i1?, let i2?):
                // Compare indices numerically
                return i1 < i2
            }
        }
    }
    
    func sortedByKeyParts() -> [String] {
        return self.sorted { (str1, str2) -> Bool in
            // Get key parts with lowercase namePart for case-insensitive comparison
            let (name1, index1) = str1.keyParts(lowercased: true)
            let (name2, index2) = str2.keyParts(lowercased: true)
            
            // Primary: Compare lowercase nameParts
            if name1 != name2 {
                return name1 < name2
            }
            
            // Secondary: Compare indexParts when nameParts match
            switch (index1, index2) {
            case (nil, nil):
                // If both have no index, keep original order (stable sort)
                return false
            case (nil, _):
                // Strings without index come before those with index
                return true
            case (_, nil):
                // Strings with index come after those without
                return false
            case (let i1?, let i2?):
                // Compare indices numerically
                return i1 < i2
            }
        }
    }
    
}
