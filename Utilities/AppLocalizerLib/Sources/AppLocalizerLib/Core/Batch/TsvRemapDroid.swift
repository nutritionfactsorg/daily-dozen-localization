//
//  TsvRemapDroid.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvRemapDroid {

    static let check = TsvRemapDroid()
    // 
    var dropSet: Set<String>
    var replaceDict: [String: String]
    var crossmapDict: [String: String] // given key_apple, then apply key_android 
    
    init() {
        dropSet = Set<String>()
        replaceDict = [String: String]()
        
        // given key_apple, then apply key_android
        crossmapDict = [String: String]()
        crossmapDict["cW5-dD-Zy0.text"] = "format_num_days"
        crossmapDict["nRL-iG-Wnd.text"] = "servings_time_scale_choices.1"
        crossmapDict["UCg-Rc-mLf.text"] = "servings_time_scale_choices.1"
        crossmapDict["lTR-i5-Tn0.text"] = "servings_time_scale_choices.1"
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
