//
//  TweakDetailInfo.swift
//  AppLocalizerLib
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
        var explanation: String = "" // replaces doze type list
        /// :NYI: 21 Tweak does not currently link to URL topics
        var topic: String = "" // item level URL path fragment
    }
    
    var itemsDict: [String: Item] = [String: Item]()
}
