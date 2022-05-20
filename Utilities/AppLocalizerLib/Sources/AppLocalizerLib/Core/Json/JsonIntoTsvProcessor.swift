//
//  JsonIntoTsvProcessor.swift
//  AppLocalizerLib
//

import Foundation

/// JsonIntoTsvProcessor converts a JSON data structure into TSV data
struct JsonIntoTsvProcessor: TsvProtocol {
    
    var tsvRowList = TsvRowList() /// [key_apple: TsvRow] 
    
    /// Read in from JSON file
    var dozeInfo: DozeDetailInfo!
    let dozeJsonUrl: URL
    /// Read in from JSON file
    var tweakInfo: TweakDetailInfo!
    let tweakJsonUrl: URL
    
    init(xliffUrl: URL, baseOrLang: TsvBaseOrLangMode) {
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
        processJsonIntoTsv(baseOrLang: baseOrLang)
    }
    
    init(dozeJsonUrl: URL, tweakJsonUrl: URL, baseOrLang: TsvBaseOrLangMode) {
        self.dozeJsonUrl = dozeJsonUrl
        self.tweakJsonUrl = tweakJsonUrl
        read(dozeJsonUrl: dozeJsonUrl, tweakJsonUrl: tweakJsonUrl)
        processJsonIntoTsv(baseOrLang: baseOrLang)
    }
    
    mutating func processJsonIntoTsv(baseOrLang: TsvBaseOrLangMode) {
        processJsonIntoTsvDoze(baseOrLang: baseOrLang)
        processJsonIntoTsvTweak(baseOrLang: baseOrLang)
    }
    
    mutating func processJsonIntoTsvDoze(baseOrLang: TsvBaseOrLangMode) {
        for entry in dozeInfo.itemsDict {
            let keyBase = entry.key
            let item = entry.value
            // heading
            var key = "\(keyBase).heading"
            put(key: key, value: item.heading, baseOrLang: baseOrLang)
            // topic
            key = "\(keyBase).topic"
            put(key: key, value: item.topic, baseOrLang: baseOrLang)
            // serving
            for i in 0 ..< item.servings.count {
                key = "\(keyBase).Serving.imperial.\(i)"
                put(key: key, value: item.servings[i].imperial, baseOrLang: baseOrLang)     
                key = "\(keyBase).Serving.metric.\(i)"
                put(key: key, value: item.servings[i].metric, baseOrLang: baseOrLang)           
            }
            // variety
            for i in 0 ..< item.varieties.count {
                key = "\(keyBase).Variety.Text.\(i)"
                put(key: key, value: item.varieties[i].text, baseOrLang: baseOrLang)
                key = "\(keyBase).Variety.topic.\(i)"
                put(key: key, value: item.varieties[i].topic, baseOrLang: baseOrLang)  
            }
        }
    }
    
    mutating func processJsonIntoTsvTweak(baseOrLang: TsvBaseOrLangMode) {
        for entry in tweakInfo.itemsDict {
            let keyBase = entry.key
            let item = entry.value
            // heading
            var key = "\(keyBase).heading"
            put(key: key, value: item.heading, baseOrLang: baseOrLang)
            // topic
            key = "\(keyBase).topic"
            put(key: key, value: item.topic, baseOrLang: baseOrLang)
            // activity
            key = "\(keyBase).Activity.imperial"
            put(key: key, value: item.activity.imperial, baseOrLang: baseOrLang)
            key = "\(keyBase).Activity.metric"
            put(key: key, value: item.activity.metric, baseOrLang: baseOrLang)
            // description (count)
            key = "\(keyBase).Explanation"
            put(key: key, value: item.explanation, baseOrLang: baseOrLang)
        }
    }
    
    private mutating func put(key: String, value: String, baseOrLang: TsvBaseOrLangMode) {
        let value = value
            .replacingOccurrences(of: "\t", with: "Ⓣ")
            .replacingOccurrences(of: "\n", with: "Ⓝ")
        if var tsvRow = tsvRowList.get(key: key, keyType: .apple) {
            // Update
            switch baseOrLang {
            case .baseMode:
                tsvRow.base_value = value                
            case .langMode:
                tsvRow.lang_value = value
            }
            tsvRowList.putRowValues(key: key, keyType: .apple, row: tsvRow)
        } else {
            // Create
            let newRow = TsvRow(
                key_android: "", 
                key_apple: key, 
                base_value: baseOrLang == .baseMode ? value : "", 
                lang_value: baseOrLang == .baseMode ? "" : value, 
                base_note: "",
                lang_note: "")
            tsvRowList.putRowValues(key: key, keyType: .apple, row: newRow)
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
    
    // MARK: - Operations
    
    // no TsvProtocol Operations overrides
    
    // MARK: - Output
    
    // no TsvProtocol Output overrides
    
}
