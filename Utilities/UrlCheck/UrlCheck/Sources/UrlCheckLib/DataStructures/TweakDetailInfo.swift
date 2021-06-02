//
//  TweakDetailInfo.swift
//  UrlCheckLib
//

import Foundation

struct TweakDetailInfo: Codable {
    
    struct Item: Codable {
                
        struct Activity: Codable { // Display Subheading: like Doze Size
            var imperial: String = ""
            var metric: String = ""
        }
        
        /// mapTweakKeys
        var heading: String = ""
        /// mapTweakDetailsShort
        var activity: Activity = Activity() // like doze size
        /// mapTweakDetailsText
        var description: [String] = [String]() // like doze type
        /// :NYI: 21 Tweak does not currently link to URL topics
        var topic: String = "" // item level URL path fragment
    }
    
    var itemsDict: [String: Item] = [String: Item]()
}
