//
//  JsonIntoTsvProcessor.swift
//  AppLocalizerLib
//

import Foundation

/// JsonIntoTsvProcessor converts a JSON data structure into TSV data
struct JsonIntoTsvProcessor {
    
    var tsvRowDict = [String: TsvRow]() /// [key_apple: TsvRow] 
    
    /// Read in from JSON file
    var dozeInfo: DozeDetailInfo!
    let dozeJsonUrl: URL
    /// Read in from JSON file
    var tweakInfo: TweakDetailInfo!
    let tweakJsonUrl: URL
    
    init(xliffUrl: URL) {
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
        read(dozeJsonUrl: dozeJsonUrl, tweakJsonUrl: tweakJsonUrl)
    }
    
    init(dozeJsonUrl: URL, tweakJsonUrl: URL) {
        self.dozeJsonUrl = dozeJsonUrl
        self.tweakJsonUrl = tweakJsonUrl
        read(dozeJsonUrl: dozeJsonUrl, tweakJsonUrl: tweakJsonUrl)
    }
    
    mutating func processJsonIntoTsv() {
        processJsonIntoTsvDoze()
        processJsonIntoTsvTweak()
    }

    mutating func processJsonIntoTsvDoze(isBaseLanguage isBase: Bool = false) {
        for entry in dozeInfo.itemsDict {
            let keyBase = entry.key
            let item = entry.value
            // heading
            var key = "\(keyBase).heading"
            put(key: key, value: item.heading, isBaseLanguage: isBase)
            // topic
            key = "\(keyBase).topic"
            put(key: key, value: item.topic, isBaseLanguage: isBase)
            // serving
            for i in 0 ..< item.servings.count {
                key = "\(keyBase).Serving.Imperial.\(i)"
                put(key: key, value: item.servings[i].imperial, isBaseLanguage: isBase)     
                key = "\(keyBase).Serving.Metric.\(i)"
                put(key: key, value: item.servings[i].metric, isBaseLanguage: isBase)           
            }
            // variety
            for i in 0 ..< item.varieties.count {
                key = "\(keyBase).Variety.Text.\(i)"
                put(key: key, value: item.varieties[i].text, isBaseLanguage: isBase)
                key = "\(keyBase).Variety.Topic.\(i)"
                put(key: key, value: item.varieties[i].topic, isBaseLanguage: isBase)  
            }
        }
    }
    
    mutating func processJsonIntoTsvTweak(isBaseLanguage isBase: Bool = false) {
        for entry in tweakInfo.itemsDict {
            let keyBase = entry.key
            let item = entry.value
            // heading
            var key = "\(keyBase).heading"
            put(key: key, value: item.heading, isBaseLanguage: isBase)
            // topic
            key = "\(keyBase).topic"
            put(key: key, value: item.topic, isBaseLanguage: isBase)
            // activity
            key = "\(keyBase).Activity.Imperial"
            put(key: key, value: item.activity.imperial, isBaseLanguage: isBase)
            key = "\(keyBase).Activity.Metric"
            put(key: key, value: item.activity.metric, isBaseLanguage: isBase)
            // description (count)
            for i in 0 ..< item.description.count {
                key = "\(keyBase).Description.\(i)"
                put(key: key, value: item.description[i], isBaseLanguage: isBase)                
            }
        }
    }
    
    private mutating func put(key: String, value: String, isBaseLanguage isBase: Bool) {
        if var tsvRow = tsvRowDict[key] {
            // Update
            if isBase {
                tsvRow.base_value = value                
            } else {
                tsvRow.lang_value = value
            }
            tsvRowDict[key] = tsvRow
        } else {
            // Create
            tsvRowDict[key] = 
                TsvRow(
                    key_android: "", 
                    key_apple: key, 
                    base_value: isBase ? value : "", 
                    lang_value: isBase ? "" : value, 
                    comments: "")            
        }
    }

    mutating func read(dozeJsonUrl: URL, tweakJsonUrl: URL) {
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
    }
    
    
    
    
}
