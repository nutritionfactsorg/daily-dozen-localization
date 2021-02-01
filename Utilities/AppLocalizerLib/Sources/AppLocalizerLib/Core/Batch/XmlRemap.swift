//
//  XmlRemap.swift
//  AppLocalizerLib
//

import Foundation

struct XmlRemap {
    
    static let check = XmlRemap()
    // 
    var dropPatternSet: Set<String>
    
    init() {
        dropPatternSet = Set<String>()
        
        // given key_apple, then apply key_android
        dropPatternSet.insert("_videos_")
    }
    
    func isDropped(_ key: String) -> Bool {
        print(key)
        for pattern in dropPatternSet {
            if key.range(of: pattern, options: .regularExpression) != nil {
                return true
            }
        }
        return false
    }
    
}
