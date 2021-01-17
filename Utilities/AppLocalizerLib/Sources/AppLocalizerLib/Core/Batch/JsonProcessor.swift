//
//  JsonProcessor.swift
//  AppLocalizerLib
//
//

import Foundation

struct JsonProcessor {
    
    /// Read in from JSON file
    var dozeInfo: DozeDetailInfo
    let dozeJsonUrl: URL
    /// Read in from JSON file
    var tweakInfo: TweakDetailInfo
    let tweakJsonUrl: URL
    //
    var keysAppleJsonAll: Set<String>       // generated from JSON data
    var keysAppleJsonMatched: Set<String>   // apple_key
    var keysAppleJsonUnmatched: Set<String> // apple_key
    
    init(xliffUrl: URL) {
        keysAppleJsonAll = Set<String>()
        keysAppleJsonMatched = Set<String>()
        keysAppleJsonUnmatched = Set<String>()
        
        let languageCode = xliffUrl
            .deletingPathExtension()
            .lastPathComponent
        let baseJsonUrl = xliffUrl
            .deletingLastPathComponent()
            .appendingPathComponent("DailyDozen")
            .appendingPathComponent("App")
            .appendingPathComponent("Texts")
            .appendingPathComponent("LocalStrings")
            .appendingPathComponent("\(languageCode).lproj")
        
        dozeJsonUrl = baseJsonUrl.appendingPathComponent("DozeDetailData.json")
        tweakJsonUrl = baseJsonUrl.appendingPathComponent("TweakDetailData.json")

        do {
            let decoder = JSONDecoder()
            let jsonDozeStr = try String(contentsOf: dozeJsonUrl, encoding: .utf8)
            let jsonDozeData = jsonDozeStr.data(using: .utf8)!
            dozeInfo = try decoder.decode(DozeDetailInfo.self, from: jsonDozeData)
            
            let jsonTweakStr = try String(contentsOf: tweakJsonUrl, encoding: .utf8)
            let jsonTweakData = jsonTweakStr.data(using: .utf8)!
            tweakInfo = try decoder.decode(TweakDetailInfo.self, from: jsonTweakData)
        } catch {            
            print("\(error)")
            fatalError()
        }
        
        // All JSON Keys
        queryAllAppleJsonKeys()
        let keysExpectedString = keysAppleJsonAll.joined(separator: "\n")
        do {
            let url = xliffUrl
                .deletingLastPathComponent()
                .appendingPathComponent("keysAppleJsonAll_\(Date.datestampyyyyMMddHHmm).txt")
            try keysExpectedString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
           print("JsonProcessor init() writing expected keys. \(error)")
        }
    }
    
    // Query all keys from data which has been read in from the JSON files. 
    mutating func queryAllAppleJsonKeys() {
        for q in dozeInfo.itemsDict {
            let key = q.key
            guard let record = dozeInfo.itemsDict[key] else { continue }
            
            keysAppleJsonAll.insert("\(key).heading")
            keysAppleJsonAll.insert("\(key).topic")
            for i in 0 ..< record.servings.count {
                keysAppleJsonAll.insert("\(key).Serving.Imperial.\(i)")                
                keysAppleJsonAll.insert("\(key).Serving.Metric.\(i)")                
            }
            for i in 0 ..< record.varieties.count {
                keysAppleJsonAll.insert("\(key).Variety.Text.\(i)")                
                keysAppleJsonAll.insert("\(key).Variety.Topic.\(i)")                
            }
        }
        
        for q in tweakInfo.itemsDict {
            let key = q.key
            guard let record = tweakInfo.itemsDict[key] else { continue }
            
            keysAppleJsonAll.insert("\(key).heading")
            keysAppleJsonAll.insert("\(key).topic")
            keysAppleJsonAll.insert("\(key).Activity.Imperial")                
            keysAppleJsonAll.insert("\(key).Activity.Metric")                
            for i in 0 ..< record.description.count {
                keysAppleJsonAll.insert("\(key).Description.\(i)")                
            }
        }
    }
    
    mutating func process(key: String, value: String) -> Bool {
        if key.hasPrefix("doze") {
            return processJsonDoze(key: key, value: value)
        } else if key.hasPrefix("tweak") {
            return processJsonTweak(key: key, value: value)
        }
        return false
    }
    
    mutating func process(lookupTable: [String: String]) {
        
    }
    
    private mutating func processJsonDoze(key: String, value: String) -> Bool {
        let parts = key.components(separatedBy: ".")
        
        if dozeInfo.itemsDict[parts[0]] != nil {
            if parts.count == 1 {
                // :NOTE:NYI: "topic" URL not processing in this import file,
                // so "heading" is the only case for parts.count == 1
                dozeInfo.itemsDict[parts[0]]?.heading = value
                keysAppleJsonMatched.insert(key)
                return true
            } else if parts.count == 4 {
                let key = parts[0]
                guard let idx = Int(parts[3]) else { return false }
                switch parts[1] {
                case "Serving":
                    switch parts[2] {
                    case "imperial":
                        // dozeBeans.Serving.imperial.1
                        dozeInfo.itemsDict[key]?.servings[idx].imperial = value
                        keysAppleJsonMatched.insert(key)
                        return true
                    case "metric":
                        // dozeBeans.Serving.metric.1
                        dozeInfo.itemsDict[key]?.servings[idx].metric = value
                        keysAppleJsonMatched.insert(key)
                        return true
                    default:
                        return false
                    }
                case "Variety":
                    switch parts[2] {
                    case "Text":
                        // dozeBerries.Variety.Text.5
                        dozeInfo.itemsDict[key]?.varieties[idx].text = value
                        keysAppleJsonMatched.insert(key)
                        return true                        
                    case "Topic":
                        // dozeBerries.Variety.Text.5
                        dozeInfo.itemsDict[key]?.varieties[idx].topic = value
                        keysAppleJsonMatched.insert(key)
                        return true                        
                    default:
                        return false
                    }
                default:
                    return false
                } 
            } 
        }
        
        return false
    }

    private mutating func processJsonTweak(key: String, value: String) -> Bool {
        let parts = key.components(separatedBy: ".")
        
        if tweakInfo.itemsDict[parts[0]] != nil {
            if parts.count == 2 {
                let key = parts[0]
                switch parts[1] {
                case "heading":
                    tweakInfo.itemsDict[parts[0]]?.heading = value
                    keysAppleJsonMatched.insert(key)
                    return true
                case "short":
                    tweakInfo.itemsDict[key]?.activity.imperial = value
                    tweakInfo.itemsDict[key]?.activity.metric = value
                    keysAppleJsonMatched.insert(key)
                    return true
                case "text":
                    tweakInfo.itemsDict[key]?.description = [value]
                    keysAppleJsonMatched.insert(key)
                    return true
                default:
                    return false
                } 
            } 
        }
        
        return false
    }
    
    func writeJsonFiles() {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        jsonEncoder.outputFormatting.insert(.sortedKeys)

        let dozeUrl = dozeJsonUrl
            .deletingPathExtension()
            .appendingPathExtension("_\(Date.datestampyyyyMMddHHmm).json")
        var data = try! jsonEncoder.encode(dozeInfo)
        var string = String(data: data, encoding: .utf8)!
        try? string.write(to: dozeUrl, atomically: true, encoding: .utf8)

        let tweakUrl = tweakJsonUrl
            .deletingPathExtension()
            .appendingPathExtension("_\(Date.datestampyyyyMMddHHmm).json")
        data = try! jsonEncoder.encode(tweakInfo)
        string = String(data: data, encoding: .utf8)!
        try? string.write(to: tweakUrl, atomically: true, encoding: .utf8)
    }
        
}
