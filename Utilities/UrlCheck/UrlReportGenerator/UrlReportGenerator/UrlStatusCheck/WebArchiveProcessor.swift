//
//  WebArchiveProcessor.swift
//  UrlReportGenerator
//

import Foundation

struct WebArchiveProcessor {
    
    static let shared = WebArchiveProcessor()
    
    //var plistData: [String:AnyObject] = [:]  // dictionary data
    //var plistData2: AnyObject! = nil // not dictionary data
        
    func getHtmlMain(plistData: Data) -> String? {
        //let validBinary = PropertyListSerialization.propertyList(
        //    plistData, // Any
        //    isValidFor: PropertyListSerialization.PropertyListFormat.binary
        //)
        //print("validBinary == \(validBinary)")
        
        // PropertyListSerialization.MutabilityOptions.mutableContainers
        // PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves
        let options: PropertyListSerialization.MutabilityOptions = []
        
        // Property List Format
        //var format: PropertyListSerialization.PropertyListFormat = .xml // .binary or .xml
        
        guard let plistDict = try? PropertyListSerialization.propertyList(
            from: plistData,  // Data
            options: options, // PropertyListSerialization.ReadOptions
            // UnsafeMutablePointer<PropertyListSerialization.PropertyListFormat>?
            format: nil // or &format
        ) as? [String:AnyObject]
        else {
            return nil
        }
        
        //print("plistDict.count == \(plistDict.count)")
        
        guard
            let mainDict = plistDict["WebMainResource"],
            let mimeType = mainDict["WebResourceMIMEType"] as? String,
            mimeType == "text/html",
            let data = mainDict["WebResourceData"] as? Data,
            let s = String(data: data, encoding: String.Encoding.utf8)
        else { return nil }
        return s
    }

    func querySearchCount(webarchive: Data) -> Int? {
        guard let html = getHtmlMain(plistData: webarchive) else { return nil }
        return querySearchCount(html: html)
    }
    
    /// :NF:SearchPage: NutritionFacts search results page
    func querySearchCount(html: String) -> Int? {
        let str = html
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
        let p = "[^0-9,.]([0-9,.]+) results <span class=\"ais-stats--time"
        let strings = str.regexSearch(pattern: p)
        
        //for i in 0 ..< strings.count {
        //    print("[\(i)] \(strings[i])")
        //}

        if strings.count > 1 {
            let intStr = strings[1]
                .replacingOccurrences(of: ",", with: "")
                .replacingOccurrences(of: ".", with: "")
            return Int(intStr)
        }
        return nil
    }
    
    func queryTopicCount(webarchive: Data) -> Int? {
        guard let html = getHtmlMain(plistData: webarchive) else { return nil }
        return queryTopicCount(html: html)
    }
    
    /// :NF:TopicPage: NutritionFacts topic webpage
    func queryTopicCount(html: String) -> Int? {
        let str = html
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
            .replacingOccurrences(of: "  ", with: " ")
        let p = "videos-count\">([0-9,.]*)<"
        let strings = str.regexSearch(pattern: p)
        
        //for i in 0 ..< strings.count {
        //    print("[\(i)] \(strings[i])")
        //}

        if strings.count > 1 {
            // remove thousands comma separator
            let intStr = strings[1]
                .replacingOccurrences(of: ",", with: "")
                .replacingOccurrences(of: ".", with: "")
            return Int(intStr)
        }
        return nil
    }

}

//(lldb) v plistAny
//([String : AnyObject]) plistAny = 1 key/value pair {
//  [0] = {
//    key = "WebMainResource"
//    value = 0x0000600001bcdc00 5 key/value pairs {
//      [0] = {
//        key = 0x0000600003b52220 "WebResourceMIMEType"
//        value = 0x623ee684295de5c3 "text/html"
//      }
//      [1] = {
//        key = 0x000060000359b8c0 "WebResourceURL"
//        value = 0x0000600003b526d0 "http://example.org/"
//      }
//      [2] = {
//        key = 0x0000600003b52460 "WebResourceFrameName"
//        value = 0x00007fff809f2ad0 ""
//      }
//      [3] = {
//        key = 0x0000600003b51920 "WebResourceData"
//        value = 0x00007f975e01fe00 1248 bytes
//      }
//      [4] = {
//        key = 0x0000600003b52910 "WebResourceTextEncodingName"
//        value = 0x663f4f953b483203 "UTF-8"
//      }
//    }
//  }
//}

//2 results
//<span class="ais-stats--time">found in 4ms</span>
