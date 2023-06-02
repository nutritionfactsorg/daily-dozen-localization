//
//  String.swift
//  AppLocalizerLib
//

import Foundation

public extension String {
    
    func keyParts(lowercased: Bool = true) -> (base: String, post: UInt?) {
        let base: String
        let postUInt: UInt?
                                
        if let i = UInt(self.suffix(3)) {
            if lowercased {
                base = String(self.dropLast(3)).lowercased()
            } else {
                base = String(self.dropLast(3))
            }
            postUInt = i
        } else if let i = UInt(self.suffix(2)) {
            if lowercased {
                base = String(self.dropLast(2)).lowercased()
            } else {
                base = String(self.dropLast(2))
            }
            postUInt = i
        } else if let i = UInt(self.suffix(1)) {
            if lowercased {
                base = String(self.dropLast()).lowercased()
            } else {
                base = String(self.dropLast())
            }
            postUInt = i
        } else {
            if lowercased {
                base = self.lowercased()
            } else {
                base = self
            }
            postUInt = nil
        }
        return (base, postUInt)
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
