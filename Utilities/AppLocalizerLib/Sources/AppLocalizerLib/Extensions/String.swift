//
//  String.swift
//  AppLocalizerLib
//

import Foundation

public extension String {
    
    /// Key Parts: namePart indexPart
    /// `A.b.21` becomes `namePart` "A.b", `indexPart` "21"
    func keyParts(lowercased: Bool = false) -> (namePart: String, indexPart: Int?) {
        let namePart: String
        let indexPart: Int?

        let regex = #/^(.*)\.(\d+)$/#
        if let match = try? regex.firstMatch(in: self) {
            namePart = String(match.1)
            indexPart = Int(match.2)
        } else {
            namePart = self
            indexPart = nil
        }
        
        if lowercased {
            return (namePart.lowercased(), indexPart)
        } else {
            return (namePart, indexPart)
        }
    }
    
    enum KeyOrderRelation {
        case lessThan
        case equalTo
        case greaterThan
    }
    
    func keyOrderRelation(to other: String) -> KeyOrderRelation {
        let left = self.keyParts(lowercased: true)
        let right = other.keyParts(lowercased: true)
        
        switch (left.namePart, right.namePart) {
        case let (l, r) where l < r:
            return .lessThan
        case let (l, r) where l > r:
            return .greaterThan
        default:
            switch (left.indexPart, right.indexPart) {
            case let (.some(l), .some(r)) where l < r:
                return .lessThan
            case let (.some(l), .some(r)) where l > r:
                return .greaterThan
            case (nil, .some(_)):
                return .greaterThan
            case (.some(_), nil):
                return .lessThan
            default:
                return .equalTo
            }
        }
    }
    
    //
    static func randomStatedJoinedStrings(list: [String]) -> (random: String, stated: String) {
        let lists = randomStatedSplit(list: list)
        let randomStr = lists.random.joined(separator: "\n")
        let statedStr = lists.stated.joined(separator: "\n")
        return (randomStr, statedStr)
    }
    
    static func randomStatedSplit(list: [String]) -> (random: [String], stated: [String]) {
        var keyRandomList = [String]()
        var keyStatedList = [String]()
        for key in list.sorted() {
            // example random key pattern: XdW-g4-ZUO.text
            if key.range(of: "^...-..-...", options: .regularExpression) != nil {
                keyRandomList.append(key)
            } else {
                keyStatedList.append(key)
            }
        }
        return (keyRandomList, keyStatedList)
    }
    
    var isRandomKey: Bool {
        if self.range(of: "^...-..-...", options: .regularExpression) != nil {
            return true
        }
        return false
    }
}

extension StringProtocol {

    func toStringCoding() -> [String] {
        var array = ["Hexadecimal | Escaped ASCII | Unicode (non-compound)"]
        //character.utf8
        for scalar: Unicode.Scalar in self.unicodeScalars { // UTF-32
            let scalarUInt32 = UInt32(scalar)
            let scalarUInt32Hex = "U+\(String(format: "%02x", scalarUInt32))" 
            let scalarAsciiStr = scalar.escaped(asASCII: true)
            array.append("\(scalarUInt32Hex) \(scalarAsciiStr) \(scalar)")
        }
        return array
    }
    
    func printStringCoding() {
        for s in toStringCoding() {
            print(s)
        }
    }

}
