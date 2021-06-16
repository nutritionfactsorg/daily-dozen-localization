//
//  DozeDetailInfo.swift
//  UrlStatusCheckLib
//

import Foundation

struct DozeDetailInfo: Codable {
    
    struct Item: Codable {
                
        struct Serving: Codable { // Display Subheading: Size
            var imperial: String = ""
            var metric: String = ""
        }
        
        struct Variety: Codable { // Display Subheading: Type
            var text: String = ""
            var topic: String = "" // example level URL path fragment
        }
        
        /// mapDozeKeys
        var heading: String = ""
        var servings: [Serving] = [Serving]()
        var varieties: [Variety] = [Variety]()
        var topic: String = "" // item level URL path fragment
    }
    
    var itemsDict: [String: Item] = [String: Item]()
}
