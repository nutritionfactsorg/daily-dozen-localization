//
//  JsonImporter.swift
//  AppLocalizerLib
//
//

import Foundation

struct JsonImporter {
    
    //
    private var dozeInfo: DozeDetailInfo
    private var tweakInfo: TweakDetailInfo
    //
    private var _lookupTable: [String: String]
    private var _keysProcessed: Set<String> // *_key
    private var _keysNotFound: Set<String> // *_key
    
    init(xliffUrl: URL, lookupTable: [String: String]) {
        _keysProcessed = Set<String>()
        _keysNotFound = Set<String>()
        _lookupTable = lookupTable
        
        let languageCode = xliffUrl
            .deletingPathExtension()
            .lastPathComponent
        let jsonBaseUrl = xliffUrl
            .deletingLastPathComponent()
            .appendingPathComponent("DailyDozen")
            .appendingPathComponent("App")
            .appendingPathComponent("Texts")
            .appendingPathComponent("LocalStrings")
            .appendingPathComponent("\(languageCode).lproj")
        
        let jsonDozeUrl = jsonBaseUrl.appendingPathComponent("DozeDetailData.json")
        let jsonTweakUrl = jsonBaseUrl.appendingPathComponent("TweakDetailData.json")

        do {
            let decoder = JSONDecoder()
            let jsonDozeStr = try String(contentsOf: jsonDozeUrl, encoding: .utf8)
            let jsonDozeData = jsonDozeStr.data(using: .utf8)!
            dozeInfo = try decoder.decode(DozeDetailInfo.self, from: jsonDozeData)
            
            let jsonTweakStr = try String(contentsOf: jsonTweakUrl, encoding: .utf8)
            let jsonTweakData = jsonTweakStr.data(using: .utf8)!
            tweakInfo = try decoder.decode(TweakDetailInfo.self, from: jsonTweakData)
        } catch {            
            print("\(error)")
            fatalError()
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
                case "servings":
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
                case "varieties":
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
        
        return false
    }
    
}
