//
//  TweakDetailsProcessor.swift
//  AppLocalizerLib
//

import Foundation

struct TweakDetailsProcessor {
    
    // 
    var tsvRecords = [String: TweakDetailsTsvRecord]()
    
    init() {
        for droid in mapTweakKeys {
            tsvRecords[droid.key] = TweakDetailsTsvRecord(androidKey: droid.key, iphoneKey: droid.value)
        }
    }
    
    mutating func readData(droidUrl: URL, isBaseLanguage: Bool) {
        
        guard 
            let droidXML = try? XMLDocument(contentsOf: droidUrl, options: []),
            let droidRootElement = droidXML.rootElement(),
            let droidL2NodeList: [XMLNode] = droidRootElement.children
            else {
                print("Failed to read \(droidUrl.path)")
                return
        }
        
        print("### ANDROID (isBaseLanguage: \(isBaseLanguage))")
        for droidL2Node: XMLNode in droidL2NodeList { 
            guard 
                let droidL2Element = droidL2Node as? XMLElement, 
                // <string       name="…">…</string>
                // <string-array name="…"><item>…</item></string>
                let name = droidL2Element.attribute(forName: "name")?.stringValue
                else { continue }
            
            if name.hasSuffix("_short") &&
                mapTweakDetailsShort[name] != nil {
                // Activity
                let key = String(name.dropLast("_short".count))
                var record = tsvRecords[key]!
                if isBaseLanguage {
                    record.base_value_short = droidL2Node.stringValue!
                } else {
                    record.lang_value_short_droid = droidL2Node.stringValue!
                    record.lang_value_short_apple_imperial = droidL2Node.stringValue!
                    record.lang_value_short_apple_metric = droidL2Node.stringValue!
                }
                tsvRecords[key] = record
                print(droidL2Element.toStringElement())
            } else if name.hasSuffix("_text") &&
                mapTweakDetailsText[name] != nil {
                // Description
                let key = String(name.dropLast("_text".count))
                var record = tsvRecords[key]!
                if isBaseLanguage {
                    record.base_value_text = droidL2Node.stringValue!
                } else {
                    record.lang_value_text_droid = droidL2Node.stringValue!
                    record.lang_value_text_apple = droidL2Node.stringValue!
                }                
                tsvRecords[key] = record
                
                print(droidL2Element.toStringElement())
            } else if mapTweakKeys[name] != nil {
                // Heading
                let key = name
                var record = tsvRecords[key]!
                if isBaseLanguage {
                    record.base_value_heading = droidL2Node.stringValue!
                } else {
                    record.lang_value_heading_droid = droidL2Node.stringValue!
                    record.lang_value_heading_apple = droidL2Node.stringValue!
                }                
                tsvRecords[key] = record
            }
            
        }
    }
    
    func toStringJson() -> String {
        var tweakDetailsInfo = TweakDetailInfo()
        
        for androidKey in tsvRecords.keys {
            let iphoneKey = mapTweakKeys[androidKey]!
            if let record = tsvRecords[androidKey] {
                let paragraphs = record.lang_value_text_apple
                    .replacingOccurrences(of: "\r\n", with: "\n")
                    .replacingOccurrences(of: "\r", with: "\n")
                    .replacingOccurrences(of: "\n\n", with: "\n")
                    .components(separatedBy: "\n")
                let item = TweakDetailInfo.Item(
                    heading: record.lang_value_heading_apple, 
                    activity: TweakDetailInfo.Item.Activity(
                        imperial: record.lang_value_short_apple_imperial, 
                        metric: record.lang_value_short_apple_metric
                    ), 
                    description: paragraphs, 
                    topic: "" // :NYI: no url topics yet.
                )
                tweakDetailsInfo.itemsDict[iphoneKey] = item
            }
        }
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        jsonEncoder.outputFormatting.insert(.sortedKeys)

        let jsonData = try! jsonEncoder.encode(tweakDetailsInfo)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    func toStringTsv(includeHeader: Bool = true) -> String {
        var s = ""
        if includeHeader {
            s.append(TweakDetailsTsvRecord.toStringTsvHeader() + "\n")
        }
        for tsv in tsvRecords {
            s.append(tsv.value.toStringTsv() + "\n")
        }
        return s
    }
    
    func writeJson(url: URL) {
        let json = self.toStringJson()
        try! json.write(to: url, atomically: false, encoding: String.Encoding.utf8)
    }
    
    func writeTsv(url: URL) {
        let tsv = self.toStringTsv()
        try! tsv.write(to: url, atomically: false, encoding: String.Encoding.utf8)
    }
    
}
