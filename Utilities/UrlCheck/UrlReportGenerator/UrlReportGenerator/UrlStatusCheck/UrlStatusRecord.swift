//
//  UrlStatusRecord.swift
//  
//

import Foundation

struct UrlStatusRecord {
    let langCode: String
    let searchItem: String
    var searchLink: URL
    var searchStatusCode: Int?
    var searchCount: Int?
    let topicItem: String?
    let topicLink: URL?
    var topicStatusCode: Int?
    var topicCount: Int?
    
    init(searchItem: String, searchLink: URL, topicItem: String?, topicLink: URL?, langCode: String) {
        self.searchItem = searchItem
        self.searchLink = searchLink
        self.topicItem = topicItem
        self.topicLink = topicLink
        self.langCode = langCode
    }
    
}
