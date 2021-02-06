//
//  XmlRemap.swift
//  AppLocalizerLib
//

import Foundation

struct XmlRemap {
    
    static let check = XmlRemap()
    
    static let dozeSet: Set<String> = [
        "food_info_serving_sizes_beans",
        "food_info_serving_sizes_berries",
        "food_info_serving_sizes_other_fruits",
        "food_info_serving_sizes_cruciferous_vegetables",
        "food_info_serving_sizes_greens",
        "food_info_serving_sizes_other_vegetables",
        "food_info_serving_sizes_flaxseeds",
        "food_info_serving_sizes_nuts",
        "food_info_serving_sizes_spices",
        "food_info_serving_sizes_whole_grains",
        "food_info_serving_sizes_beverages",
        "food_info_serving_sizes_exercise"
    ]

    // 
    var dropPatternSet: Set<String>
    
    init() {
        dropPatternSet = Set<String>()
        
        // given key_apple, then apply key_android
        dropPatternSet.insert("_videos_")
    }
    
    func isDropped(_ key: String) -> Bool {
        // print("XmlRemap dropped: \(key)")
        for pattern in dropPatternSet {
            if key.range(of: pattern, options: .regularExpression) != nil {
                return true
            }
        }
        return false
    }
    
}
