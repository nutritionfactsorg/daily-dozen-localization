//
//  TsvRemapDroid.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvRemapDroid {

    static let check = TsvRemapDroid()
    /// given key as `key_android`, then delete tsv row
    var dropSet: Set<String>
    /// given key as `key_android`, then apply value to update `key_android`for tsv row
    var replaceDict: [String: String]
    /// given key as `key_apple`, then apply value as `key_android` for tsv row
    var crossmapDict: [String: String]  
    
    init() {
        dropSet = Set<String>()
        
        replaceDict = [String: String]()
        
        crossmapDict = [String: String]()
    }
    
    func isDropped(_ key: String) -> Bool {
        return dropSet.contains(key)
    }

    func isReplaced(_ key: String) -> String? {
        return replaceDict[key]
    }
    
    /// Returns an Android key which crossmaps to an Apple key
    func isCrossmapUpdated(_ r: TsvRow) -> String? {
        if let key = crossmapDict[r.key_apple] {
            return key
        }
        return nil
    }
    
    func isPatched(_ r: TsvRow) -> String? {
        // TSV v1 fix patch: imperial & metric were swapped
        if r.key_android == "imperial" && r.base_value == "metric" {
            return "metric"
        }
        if r.key_android == "metric" && r.base_value == "imperial" {
            return "imperial"
        }
        return nil
    }
    
}
