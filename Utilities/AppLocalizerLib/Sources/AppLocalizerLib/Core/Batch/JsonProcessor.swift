//
//  JsonProcessor.swift
//  AppLocalizerLib
//
//

import Foundation

struct JsonProcessor {
    
    //
    var dozeInfo: DozeDetailInfo
    let dozeJsonUrl: URL
    var tweakInfo: TweakDetailInfo
    let tweakJsonUrl: URL
    //
    private var _lookupTable: [String: String]
    private var _keysProcessed: Set<String> // apple_key
    private var _keysNotFound: Set<String>  // apple_key
    private var _keysExpected: Set<String>  // generated from JSON
    
    init(xliffUrl: URL, lookupTable: [String: String]) {
        _keysProcessed = Set<String>()
        _keysNotFound = Set<String>()
        _keysExpected = Set<String>()
        _lookupTable = lookupTable
        
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
        
        // Expected JSON Keys
        generateExpectedKeys()
        let keysExpectedString = _keysExpected.joined(separator: "\n")
        do {
            let url = xliffUrl
                .deletingLastPathComponent()
                .appendingPathComponent("keysExpectedJson_\(Date.datestampyyyyMMddHHmm).txt")
            try keysExpectedString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
           print("JsonProcessor init() writing expected keys. \(error)")
        }
    }
    
    mutating func generateExpectedKeys() {
        for q in dozeInfo.itemsDict {
            let key = q.key
            guard let record = dozeInfo.itemsDict[key] else { continue }
            
            _keysExpected.insert("\(key).heading")
            _keysExpected.insert("\(key).topic")
            for i in 0 ..< record.servings.count {
                _keysExpected.insert("\(key).Serving.Imperial.\(i)")                
                _keysExpected.insert("\(key).Serving.Metric.\(i)")                
            }
            for i in 0 ..< record.varieties.count {
                _keysExpected.insert("\(key).Variety.Text.\(i)")                
                _keysExpected.insert("\(key).Variety.Topic.\(i)")                
            }
        }
        
        for q in tweakInfo.itemsDict {
            let key = q.key
            guard let record = tweakInfo.itemsDict[key] else { continue }
            
            _keysExpected.insert("\(key).heading")
            _keysExpected.insert("\(key).topic")
            _keysExpected.insert("\(key).Activity.Imperial")                
            _keysExpected.insert("\(key).Activity.Metric")                
            for i in 0 ..< record.description.count {
                _keysExpected.insert("\(key).Description.\(i)")                
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
    
    private mutating func processJsonDoze(key: String, value: String) -> Bool {
        let parts = key.components(separatedBy: ".")
        
        if dozeInfo.itemsDict[parts[0]] != nil {
            if parts.count == 1 {
                // :NOTE:NYI: "topic" URL not processing in this import file,
                // so "heading" is the only case for parts.count == 1
                dozeInfo.itemsDict[parts[0]]?.heading = value
                _keysProcessed.insert(key)
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
                        _keysProcessed.insert(key)
                    case "metric":
                        // dozeBeans.Serving.metric.1
                        dozeInfo.itemsDict[key]?.servings[idx].metric = value
                        _keysProcessed.insert(key)
                    default:
                        return false
                    }
                    return true
                case "Variety":
                    switch parts[2] {
                    case "Text":
                        // dozeBerries.Variety.Text.5
                        dozeInfo.itemsDict[key]?.varieties[idx].text = value
                        _keysProcessed.insert(key)
                        return true                        
                    case "Topic":
                        // dozeBerries.Variety.Text.5
                        dozeInfo.itemsDict[key]?.varieties[idx].topic = value
                        _keysProcessed.insert(key)
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
                    _keysProcessed.insert(key)
                    return true
                case "short":
                    tweakInfo.itemsDict[key]?.activity.imperial = value
                    tweakInfo.itemsDict[key]?.activity.metric = value
                    _keysProcessed.insert(key)
                    return true
                case "text":
                    tweakInfo.itemsDict[key]?.description = [value]
                    _keysProcessed.insert(key)
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
