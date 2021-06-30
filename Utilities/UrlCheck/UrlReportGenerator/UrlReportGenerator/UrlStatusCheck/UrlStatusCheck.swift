//
//  UrlStatusCheck.swift
//  UrlStatusCheckLib
//

import Foundation
import WebKit

public final class UrlStatusCheck {
    let langBoundaryIdx_es = 258 // Legumbres based on tsv file
    // Singleton
    public static let shared = UrlStatusCheck()
    // Properties
    private let _baseUrl: URL!
    private var _status404 = [String]()
    private var _list = [UrlStatusRecord]()
    
    /// NYI: does provide for a terminationHandler(Process) -> Void
    public init() {
        _baseUrl = Bundle.resourceModuleDir
    }

    func append404(index: Int) {
        guard index < _list.count else { return }
        let slot: Int = index / 2
        if index % 2 == 0 { // search page
            _status404.append(_list[slot].searchItem)
        } else { // topic page
            if let topicItem = _list[slot].topicItem {
                _status404.append(topicItem)
            } else {
                print("ERROR: append404 @\(index) [\(slot)] -topic- not found")
            }
        }
    }
    
    func code(index: Int) -> Int? {
        let slot: Int = index / 2
        guard slot < _list.count else { return nil }
        if index % 2 == 0 {
            return _list[slot].searchStatusCode
        } else {
            if let code = _list[slot].topicStatusCode {
                return code
            } else {
                return nil
            }
        }
    }

    func item(index: Int) -> String? {
        let slot: Int = index / 2
        guard slot < _list.count else { return nil }
        if index % 2 == 0 {
            return _list[slot].searchItem
        } else {
            if let topicItem = _list[slot].topicItem {
                return topicItem
            } else {
                return nil
            }
        }
    }

    func link(index: Int) -> URL? {
        let slot: Int = index / 2
        guard slot < _list.count else { return nil }
        if index % 2 == 0 {
            return _list[slot].searchLink
        } else {
            if let topicLink = _list[slot].topicLink {
                return topicLink
            } else {
                return nil
            }
        }
    }
    
    func linkFirst() -> URL {
        return _list[0].searchLink
    }

    func linkNext(index: Int) -> (index: Int, url: URL)? {
        var nextIndex = index + 1
        var nextSlot: Int = nextIndex / 2
        guard nextSlot < _list.count else { return nil }
        if nextIndex % 2 == 0 {
            return (nextIndex, _list[nextSlot].searchLink)
        } else {
            if let topicLink = _list[nextSlot].topicLink {
                return (nextIndex, topicLink)
            } else {
                nextIndex = nextIndex + 1
                nextSlot = nextIndex / 2
                guard nextSlot < _list.count else { return nil }
                return (nextIndex, _list[nextSlot].searchLink)
            }
        }
    }
    
    func updateCount(index: Int, count: Int) {
        let slot: Int = index / 2
        if index % 2 == 0 {
            _list[slot].searchCount = count
        } else {
            _list[slot].topicCount = count
        }
    }
    
    func updateStatus(index: Int, statusCode: Int) {
        let slot: Int = index / 2
        if index % 2 == 0 {
            _list[slot].searchStatusCode = statusCode
        } else {
            _list[slot].topicStatusCode = statusCode
        }
    }
    
    func writeWebArchive(index: Int, name: String, data: Data) {
        let outUrl = _baseUrl
            .deletingLastPathComponent() // UrlReportGenerator.app
            .appendingPathComponent("[\(index)]_\(name).webarchive")
        
        do {
            try data.write(to: outUrl, options: .atomic)
        } catch {
            print("writeWebArchive() \(error)")
        }
        
        let outHtmlUrl = _baseUrl
            .deletingLastPathComponent() // UrlReportGenerator.app
            .appendingPathComponent("[\(index)]_\(name).html")
        let processor = WebArchiveProcessor.shared
        if let html = processor.getHtmlMain(plistData: data) {
            do {
                try html.write(to: outHtmlUrl, atomically: true, encoding: .utf8)
            } catch {
                print("writeWebArchive() html \(error)")
            }
        }

    }

    func writeHtml(index: Int, name: String, html: String) {
        let outUrl = _baseUrl
            .deletingLastPathComponent() // UrlReportGenerator.app
            .appendingPathComponent("[\(index)]_\(name).html")
        
        do {
            try html.write(to: outUrl, atomically: true, encoding: .utf8)
        } catch {
            print("writeHtml() \(error)")
        }
    }

    func writeReport() {
        let outUrl = _baseUrl
            .deletingLastPathComponent() // UrlReportGenerator.app
            .appendingPathComponent("Report.md")
        let s = toString(withCounts: true)
        do {
            try s.write(to: outUrl, atomically: true, encoding: .utf8)
        } catch {
            print("writeReport() \(error)")
        }
        print(outUrl.absoluteString)
    }
    
    // MARK: - Load Data
    
    public func load() {
        loadJsonInfo(languageCode: "en")
        loadJsonInfo(languageCode: "es")
        loadTsvSearchTerms()
        //print("BEGIN ITEMS")
        //for i in 0 ..< _list.count {
        //    print("\(i)\t\(_list[i].searchItem)")
        //}
        //print("END ITEMS")
        print("UrlStatusCheck load: \(_list.count)")
    }
    
    func loadJsonInfo(languageCode: String) {
        // Read in from JSON file
        let baseJsonUrl = _baseUrl
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Resources")
            .appendingPathComponent("\(languageCode).lproj")
        let dozeJsonUrl = baseJsonUrl.appendingPathComponent("DozeDetailData.json")
        let tweakJsonUrl = baseJsonUrl.appendingPathComponent("TweakDetailData.json")
        
        do {
            let decoder = JSONDecoder()
            let jsonDozeStr = try String(contentsOf: dozeJsonUrl, encoding: .utf8)
            let jsonDozeData = jsonDozeStr.data(using: .utf8)!
            let dozeInfo = try decoder.decode(DozeDetailInfo.self, from: jsonDozeData)
            loadJsonDozeInfo(dozeInfo, languageCode: languageCode)
            
            let jsonTweakStr = try String(contentsOf: tweakJsonUrl, encoding: .utf8)
            let jsonTweakData = jsonTweakStr.data(using: .utf8)!
            let tweakInfo = try decoder.decode(TweakDetailInfo.self, from: jsonTweakData)
            loadJsonTweakInfo(tweakInfo, languageCode: languageCode)
        } catch {
            print("\(error)")
            fatalError()
        }
        
        print(":COMPLETED: loadJsonInfo \(languageCode)")
    }
    
    func loadJsonDozeInfo(_ info: DozeDetailInfo, languageCode: String) {
        for key in info.itemsDict.keys.sorted() {
            let item = info.itemsDict[key]!
            
            _list.append(
                UrlStatusRecord(
                    searchItem: item.heading,
                    searchLink: toWeblinkSearch(item.heading, languageCode: languageCode),
                    topicItem: item.topic,
                    topicLink: toWeblinkTopic(item.topic, languageCode: languageCode),
                    langCode: languageCode
                )
            )
            
            for variety in item.varieties {
                _list.append(
                    UrlStatusRecord(
                        searchItem: variety.text,
                        searchLink: toWeblinkSearch(variety.text, languageCode: languageCode),
                        topicItem: variety.topic,
                        topicLink: toWeblinkTopic(variety.topic, languageCode: languageCode),
                        langCode: languageCode
                    )
                )
            }
        }
    }
    
    func loadJsonTweakInfo(_ info: TweakDetailInfo, languageCode: String) {
        for key in info.itemsDict.keys.sorted() {
            let item = info.itemsDict[key]!
            
            _list.append(
                UrlStatusRecord(
                    searchItem: item.heading,
                    searchLink: toWeblinkSearch(item.heading, languageCode: languageCode),
                    topicItem: item.topic,
                    topicLink: toWeblinkTopic(item.topic, languageCode: languageCode),
                    langCode: languageCode
                )
            )
        }
    }
    
    func loadTsvSearchTerms() {
        // Read in from TSV file
        let baseTsvUrl = _baseUrl
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Resources")
            .appendingPathComponent("resource_search.tsv")
        guard let termStr = try? String(contentsOf: baseTsvUrl, encoding: .utf8)
        else {
            fatalError("resource_search.tsv not found")
        }
        let lines = termStr.components(separatedBy: "\n")
        for l in lines {
            guard l.isEmpty == false else { continue }
            let parts = l.components(separatedBy: "\t")
            guard
                parts.count >= 2,
                let index = Int(parts[0].trimmingCharacters(in: CharacterSet.whitespaces))
            else { continue }
            if index < langBoundaryIdx_es {
                _list[index].searchLink = toWeblinkSearch(parts[1], languageCode: "en")
            } else {
                _list[index].searchLink = toWeblinkSearch(parts[1], languageCode: "es")
            }
        }
        //for i in 0 ..< 6 {
        //    print("[\(i)] '\(_list[i].searchItem)' \(_list[i].searchLink)")
        //}
    }
    
    // MARK: - To Strings
    
    func toString(withCounts: Bool = false) -> String {
        var s = mdHeader
        
        s.append("\n\n### English")
        s.append(withCounts ? mdTableCountsHeader : mdTableHeader)
        // loadJsonInfo(languageCode: "en")
        for r: UrlStatusRecord in _list where r.langCode == "en" {
            s.append(mdTableRowBegin)
            // Search Page: title
            s.append("  <td><a href='\(r.searchLink)'>\(r.searchItem)</a></td>\n")
            if withCounts {
                if let c = r.searchCount, c > 0 {
                    s.append("  <td>\(c)</td>\n")
                } else {
                    s.append("  <td></td>\n") // empty row
                }
            }
            // Topic Page
            if let topic = r.topicItem, let link = r.topicLink {
                if let statusCode = r.topicStatusCode {
                    s.append("  <td><a href='\(link)'>\(topic)</a></td>\n  <td>\(statusCode)</td>\n")
                } else {
                    s.append("  <td><a href='\(link)'>\(topic)</a></td>\n  <td></td>\n")
                }
            } else {
                s.append("  <td></td>\n  <td></td>\n")
            }
            if withCounts {
                if let c = r.topicCount, c > 0 {
                    s.append("  <td>\(c)</td>\n")
                } else {
                    s.append("  <td></td>\n") // empty row
                }
            }
            s.append(mdTableRowEnd)
        }
        s.append(mdTableFooter)
        
        s.append("\n\n### Spanish")
        s.append(withCounts ? mdTableCountsHeader : mdTableHeader)
        // loadJsonInfo(languageCode: "es")
        for r: UrlStatusRecord in _list where r.langCode == "es" {
            s.append(mdTableRowBegin)
            // Search Page: title
            s.append("  <td><a href='\(r.searchLink)'>\(r.searchItem)</a></td>\n")
            if withCounts {
                if let c = r.searchCount, c > 0 {
                    s.append("  <td>\(c)</td>\n")
                } else {
                    s.append("  <td></td>\n") // empty row
                }
            }
            // Topic Page
            if let topic = r.topicItem, let link = r.topicLink {
                if let statusCode = r.topicStatusCode {
                    s.append("  <td><a href='\(link)'>\(topic)</a></td>\n  <td>\(statusCode)</td>\n")
                } else {
                    s.append("  <td><a href='\(link)'>\(topic)</a></td>\n  <td></td>\n")
                }
            } else {
                s.append("  <td></td>\n  <td></td>\n")
            }
            if withCounts {
                if let c = r.topicCount, c > 0 {
                    s.append("  <td>\(c)</td>\n")
                } else {
                    s.append("  <td></td>\n") // empty row
                }
            }
            s.append(mdTableRowEnd)
        }
        s.append(mdTableFooter)
        
        s.append("\n\n### HTTP Status: 404 Not Found\n\n(count: \(_status404.count))\n\n")
        for item404 in _status404 {
            s.append("* \(item404)\n")
        }
        s.append("\n")
        
        return s
    }
    
    /// returns: title search web link
    func toWeblinkSearch(_ title: String, languageCode: String) -> URL {
        guard title.isEmpty == false else {
            fatalError("toWeblinkSearch `title` is required")
        }
        var link: URL!
        var s = title
        s = s.replacingOccurrences(of: "(", with: " ")
        s = s.replacingOccurrences(of: ")", with: " ")
        s = s.replacingOccurrences(of: ",", with: " ")
        s = s.replacingOccurrences(of: "¼", with: "")
        s = s.replacingOccurrences(of: "½", with: "")
        s = s.replacingOccurrences(of: "\"", with: "")
        s = s.replacingOccurrences(of: "\\", with: "")
        s = s.replacingOccurrences(of: "  ", with: " ")
        s = s.replacingOccurrences(of: "  ", with: " ")
        s = s.replacingOccurrences(of: "  ", with: " ")
        let parts = s.components(separatedBy: " ")
        
        var t = "\"\(parts[0])\""
        var i = 1
        while i < parts.count {
            if parts[i].isEmpty == false {
                t = t.appending("+\"\(parts[i])\"")
            }
            i += 1
        }
        
        t = t.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed) ?? t
        if languageCode == "en" {
            // https://nutritionfacts.org/?s=%22water%22
            // https://nutritionfacts.org/?s="preload"+"water"
            let webpath = "https://nutritionfacts.org/?s=\(t)"
            //print(webpath)
            link = URL(string: webpath)
        } else {
            // https://nutritionfacts.org/es/?s=%22aqua%22
            let webpath = "https://nutritionfacts.org/\(languageCode)/?s=\(t)"
            //print(webpath)
            link = URL(string: webpath)
        }
        return link!
    }
    
    /// returns: topic page web link
    func toWeblinkTopic(_ topic: String, languageCode: String) -> URL? {
        guard topic.isEmpty == false else { return nil }
        // https://nutritionfacts.org/topics/water/
        // https://nutritionfacts.org/es/topics/agua/ (lang code already in json)
        let link = URL(string: "https://nutritionfacts.org/\(topic)/")
        return link!
    }
    
}

public extension UrlStatusCheck {
    enum Error: Swift.Error {
        case missingArgument
        case failedToDoSomething
    }
}

let mdHeader = """
# URL Link Check Report

"""

let mdTableHeader = """

<table style="width:100%; font-family: monospace;">
<tr>
  <th>Title</th>
  <th>Topic</th>
  <th>status</th>
</tr>

"""

let mdTableCountsHeader = """

<table style="width:100%; font-family: monospace;">
<tr>
  <th>Title</th>
  <th>#</th>
  <th>Topic</th>
  <th>status</th>
  <th>#</th>
</tr>

"""

let mdTableFooter = """
</table>

"""

let mdTableRowBegin = "<tr>\n"

let mdTableRowEnd = "</tr>\n"

let exampleHtml = """
<table style="width:100%; font-family: monospace;">
<tr>
  <th>Title</th>
  <th>Topic</th>
  <th>#</th>
</tr>
<tr>
  <td>Preload Water</td>
  <td>2</td>
  <td></td>
  <td></td>
</tr>
</table>
"""
