//
//  String.swift
//  AppLocalizerLib
//
//  Created by marc on 2021.01.20.
//

import Foundation

public extension String {
    
    static func joinRandomStated(list: [String]) -> String {
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
        
        return (keyStatedList + ["--------- RANDOM KEYS ---------"] + keyRandomList).joined(separator: "\n")
    }
    
    var isRandomKey: Bool {
        if self.range(of: "^...-..-...", options: .regularExpression) != nil {
            return true
        }
        return false
    }
}
