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
        
        // Android Store: change word separators from `.` to `_`
        replaceDict["android.store.title"] = "android_store_title"
        replaceDict["store.keywords"] = "store_keywords"
        replaceDict["store.screen.0"] = "store_screen.0"
        replaceDict["store.screen.1"] = "store_screen.1"
        replaceDict["store.screen.2"] = "store_screen.2"
        replaceDict["store.screen.3"] = "store_screen.3"
        replaceDict["store.screen.4"] = "store_screen.4"
        replaceDict["store.screen.5"] = "store_screen.5"
        replaceDict["android.store.description.0"] = "android_store_description.0"
        replaceDict["android.store.description.1"] = "android_store_description.1"
        replaceDict["android.store.description.2"] = "android_store_description.2"
        replaceDict["android.store.whatsnew"] = "android_store_whatsnew"
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
        // :WIP:???: can imperial & metric were swapped patch be removed?
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
