//
//  Test.swift
//  AppLocalizerLib
//
//  Created by mc on 2025.04.08.
//

import Testing

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
}

struct Test {
    
    @Test func testSortByKeyParts() async throws {
        var stringList = ["A.b.21", "a.b.1", "B.c.5", "A.b.2", "C.d", "a.B.10"]
        stringList.sortByKeyParts()
        print("\(stringList)")
        // Result: ["a.b.1", "a.B.10", "A.b.2", "A.b.21", "B.c.5", "C.d"]
    }

}
