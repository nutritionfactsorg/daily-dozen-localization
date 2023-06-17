//
//  UrlCheck.swift
//  UrlCheckLib
//

import Foundation

public final class UrlCheck {
    private let arguments: [String]

    private let _baseUrl: URL!
    
    private var _mdout = ""
    private var _status404 = [String]()
    
    /// NYI: does provide for a terminationHandler(Process) -> Void
    public init(arguments: [String] = CommandLine.arguments) { 
        self.arguments = arguments
        _baseUrl = Bundle.resourceModuleDir
    }

    public func run() throws {
        _mdout.append(mdHeader)
        
        _mdout.append("\n\n### English")
        _mdout.append(mdTableHeader)
        processJsonSource(languageCode: "en")
        _mdout.append(mdTableFooter)

        _mdout.append("\n\n### Spanish")
        _mdout.append(mdTableHeader)
        processJsonSource(languageCode: "es")
        _mdout.append(mdTableFooter)
        
        _mdout.append("\n\n### HTTP Status: 404 Not Found (count: \(_status404.count))\n\n")
        print("\n\n### HTTP Status: 404 Not Found (count: \(_status404.count))\n")
        for s in _status404 {
            _mdout.append("* \(s)\n")
            print(s)
        }
        _mdout.append("\n")
        print("\n")
        
        let outUrl = _baseUrl.appendingPathComponent("Report.md")
        try _mdout.write(to: outUrl, atomically: true, encoding: .utf8)
        
        print(outUrl.absoluteString)
        print(":COMPLETED: run")
    }
    
    func processJsonSource(languageCode: String) {
        /// Read in from JSON file
        let baseJsonUrl = _baseUrl
            .appendingPathComponent("UrlCheckLib_UrlCheckLib.bundle")
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Resources")
            .appendingPathComponent("\(languageCode).lproj")
        let dozeJsonUrl = baseJsonUrl.appendingPathComponent("DozeDetailData.json")
        let tweakJsonUrl = baseJsonUrl.appendingPathComponent("TweakDetailData.json")

        do {
            print(":PROCESSING: \(dozeJsonUrl.lastPathComponent)")
            let decoder = JSONDecoder()
            let jsonDozeStr = try String(contentsOf: dozeJsonUrl, encoding: .utf8)
            let jsonDozeData = jsonDozeStr.data(using: .utf8)!
            let dozeInfo = try decoder.decode(DozeDetailInfo.self, from: jsonDozeData)
            checkDozeInfo(dozeInfo, languageCode: languageCode)
        } catch {
            print("doze \(error)")
            fatalError()
        }

        do {
            print(":PROCESSING: \(tweakJsonUrl.lastPathComponent)")
            let decoder = JSONDecoder()
            let jsonTweakStr = try String(contentsOf: tweakJsonUrl, encoding: .utf8)
            let jsonTweakData = jsonTweakStr.data(using: .utf8)!
            let tweakInfo = try decoder.decode(TweakDetailInfo.self, from: jsonTweakData)
            checkTweakInfo(tweakInfo, languageCode: languageCode)
        } catch {
            print("tweaks \(error)")
            fatalError()
        }

        print(":COMPLETED: processJsonSource \(languageCode)")
    }
    
    func checkDozeInfo(_ info: DozeDetailInfo, languageCode: String) {
        for key in info.itemsDict.keys.sorted() {
            let item = info.itemsDict[key]!
            
            _mdout.append(mdTableRowBegin)
            _mdout.append(toTitleLink(item.heading, languageCode: languageCode))
            _mdout.append(toTopicLink(item.topic, languageCode: languageCode))
            _mdout.append(mdTableRowEnd)

            for variety in item.varieties {
                _mdout.append(mdTableRowBegin)
                _mdout.append(toTitleLink(variety.text, languageCode: languageCode))
                _mdout.append(toTopicLink(variety.topic, languageCode: languageCode))
                _mdout.append(mdTableRowEnd)
            }
        }
    }
    
    func checkTweakInfo(_ info: TweakDetailInfo, languageCode: String) {
        
    }
    
    func checkHttpUrl(urlString: String) -> Int {
        guard let url = URL(string: urlString) else { return -1 }
        
        //let (data, response, error)
        let (_, response, _) = URLSession.shared.syncRequest(with: url)
        if let httpResponse = response as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        
        return -2
    }
    
    func toTitleLink(_ title: String, languageCode: String) -> String {
        guard title.isEmpty == false else { return "  <td></td>\n" }
        var s = title
        s = s.replacingOccurrences(of: "(", with: " ")
        s = s.replacingOccurrences(of: ")", with: " ")
        s = s.replacingOccurrences(of: ",", with: " ")
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
        
        if languageCode == "en" {
            // https://nutritionfacts.org/?s=%22water%22
            // https://nutritionfacts.org/?s="preload"+"water"
            let link = "https://nutritionfacts.org/?s=\(t)"
            //checkHttpUrl(urlString: link)
            return "  <td><a href='\(link)'>\(title)</a></td>\n"
        } else {
            // https://nutritionfacts.org/es/?s=%22aqua%22
            let link = "https://nutritionfacts.org/\(languageCode)/?s=\(t)"
            //checkHttpUrl(urlString: link)
            return "  <td><a href='\(link)'>\(title)</a></td>\n"
        }
    }

    func toTopicLink(_ topic: String, languageCode: String) -> String {
        guard topic.isEmpty == false else { return "  <td></td>\n  <td></td>\n" }
        
        // https://nutritionfacts.org/topics/water/
        // https://nutritionfacts.org/es/topics/agua/ (lang code in json)
        let link = "https://nutritionfacts.org/\(topic)/"
        let status = checkHttpUrl(urlString: link)
        if status == 404 {
            _status404.append("\(topic)")
        }
        return "  <td><a href='\(link)'>\(topic)</a></td>\n  <td>\(status)</td>\n"
    }
}

public extension UrlCheck {
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
