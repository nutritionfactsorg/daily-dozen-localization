//
//  DozeDetailsProcessor.swift
//  AppLocalizerLib
//

import Foundation

struct DozeDetailsProcessor {
    
    // Android
    var androidBaseRecords = [String: DozeDetailsDroidRecord]()
    var androidLangRecords = [String: DozeDetailsDroidRecord]()
    
    // TSV Records. Contains both base and lang values
    var tsvMainRecords = [String: DozeDetailsTsvMainRecord]()
    var tsvServingRecords = [String: [DozeDetailsTsvServingRecord]]()
    var tsvVarietyRecords = [String: [DozeDetailsTsvVarietyRecord]]()
    
    init() {
        for droid in mapDozeDetailsKeys {
            androidBaseRecords[droid.key] = DozeDetailsDroidRecord()
            androidLangRecords[droid.key] = DozeDetailsDroidRecord()
            tsvMainRecords[droid.key] = DozeDetailsTsvMainRecord(androidKey: droid.key, iphoneKey: droid.value)
            tsvServingRecords[droid.key] = [DozeDetailsTsvServingRecord]()
            tsvVarietyRecords[droid.key] = [DozeDetailsTsvVarietyRecord]()
        }
    }
    
    private func blend(_ a: String, _ b: String) -> String {
        if a.isEmpty { return b }
        if b.isEmpty { return a } 
        return b.replacingOccurrences(of: "%s", with: a)
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
            
            if name.hasPrefix("food_info_serving_sizes_") &&
                name.hasSuffix("_imperial") {
                // SERVING: food_info_serving_sizes_key_imperial unit values
                let androidKey = String(name
                    .dropFirst("food_info_serving_sizes_".count)
                    .dropLast("_imperial".count)
                )
                let iphoneKey = mapDozeDetailsKeys[androidKey]! + "Serving"
                var recordList = tsvServingRecords[androidKey]!
                
                if let droidL3NodeList = droidL2Element.children {
                    if recordList.count == 0 {
                        recordList = [DozeDetailsTsvServingRecord](repeating: DozeDetailsTsvServingRecord(androidKey: name, iphoneKey: iphoneKey), count: droidL3NodeList.count)
                    }
                    
                    if recordList.count == droidL3NodeList.count {
                        for i in 0 ..< droidL3NodeList.count {
                            let droidL3Node: XMLNode = droidL3NodeList[i]
                            guard 
                                let droidL3Element = droidL3Node as? XMLElement, 
                                // <item/>, <item>…</item>
                                let value = droidL3Element.stringValue
                                else { continue }
                            if isBaseLanguage { 
                                recordList[i].base_imperial = blend(value, recordList[i].base_imperial)
                            } else {
                                recordList[i].lang_imperial_droid = blend(value, recordList[i].lang_imperial_droid)
                                recordList[i].lang_imperial_apple = blend(value, recordList[i].lang_imperial_apple)
                            }
                            recordList[i].sequence = i
                        }
                    } else {
                        print(":ERROR: \(name) array size mismatch")
                    }
                } else { fatalError() }
                tsvServingRecords[androidKey] = recordList
                
            } else if name.hasPrefix("food_info_serving_sizes_") &&
                name.hasSuffix("_metric") {
                // SERVING: food_info_serving_sizes_key_metric unit values
                let androidKey = String(name
                    .dropFirst("food_info_serving_sizes_".count)
                    .dropLast("_metric".count)
                )
                let iphoneKey = mapDozeDetailsKeys[androidKey]! + "Serving"
                var recordList = tsvServingRecords[androidKey]!
                
                if let droidL3NodeList = droidL2Element.children {
                    if recordList.count == 0 {
                        recordList = [DozeDetailsTsvServingRecord](repeating: DozeDetailsTsvServingRecord(androidKey: name, iphoneKey: iphoneKey), count: droidL3NodeList.count)
                    }
                    
                    if recordList.count == droidL3NodeList.count {
                        for i in 0 ..< droidL3NodeList.count {
                            let droidL3Node: XMLNode = droidL3NodeList[i]
                            guard 
                                let droidL3Element = droidL3Node as? XMLElement, 
                                // <item/>, <item>…</item>
                                let value = droidL3Element.stringValue
                                else { continue }
                            if isBaseLanguage { 
                                recordList[i].base_metric = blend(value, recordList[i].base_metric)
                            } else {
                                recordList[i].lang_metric_droid = blend(value, recordList[i].lang_metric_droid)
                                recordList[i].lang_metric_apple = blend(value, recordList[i].lang_metric_apple)
                            }
                            recordList[i].sequence = i
                        }
                    } else {
                        print(":ERROR: \(name) array size mismatch")
                    }
                } else { fatalError() }
                tsvServingRecords[androidKey] = recordList
                
            } else if name.hasPrefix("food_info_serving_sizes_") {
                // SERVING: food_info_serving_sizes_key text
                let androidKey = String(name.dropFirst("food_info_serving_sizes_".count))
                let iphoneKey = mapDozeDetailsKeys[androidKey]! + "Serving"
                var recordList = tsvServingRecords[androidKey]!
                
                if let droidL3NodeList = droidL2Element.children {
                    if recordList.count == 0 {
                        recordList = [DozeDetailsTsvServingRecord](repeating: DozeDetailsTsvServingRecord(androidKey: name, iphoneKey: iphoneKey), count: droidL3NodeList.count)
                    }
                    
                    if recordList.count == droidL3NodeList.count {
                        for i in 0 ..< droidL3NodeList.count {
                            let droidL3Node: XMLNode = droidL3NodeList[i]
                            guard 
                                let droidL3Element = droidL3Node as? XMLElement, 
                                // <item/>, <item>…</item>
                                let value = droidL3Element.stringValue
                                else { continue }
                            if isBaseLanguage { 
                                recordList[i].base_imperial = blend(recordList[i].base_imperial, value)
                                recordList[i].base_metric = blend(recordList[i].base_metric, value)
                            } else {
                                recordList[i].lang_imperial_droid = blend(recordList[i].lang_imperial_droid, value)
                                recordList[i].lang_imperial_apple = blend(recordList[i].lang_imperial_apple, value)
                                recordList[i].lang_metric_droid = blend(recordList[i].lang_metric_droid, value)
                                recordList[i].lang_metric_apple = blend(recordList[i].lang_metric_apple, value)
                            }
                            recordList[i].sequence = i
                        }
                    } else {
                        print(":ERROR: \(name) array size mismatch")
                    }
                } else { fatalError() }
                tsvServingRecords[androidKey] = recordList
                
            } else if name.hasPrefix("food_info_types_") {
                // VARIETY: description text
                let androidKey = String(name.dropFirst("food_info_types_".count))
                let iphoneKey = mapDozeDetailsKeys[androidKey]! + "VarietyText"
                var recordList = tsvVarietyRecords[androidKey]!
                if let droidL3NodeList = droidL2Element.children {
                    if recordList.count == 0 {
                        recordList = [DozeDetailsTsvVarietyRecord](repeating: DozeDetailsTsvVarietyRecord(androidKey: name, iphoneKey: iphoneKey), count: droidL3NodeList.count)
                    }
                    
                    if recordList.count == droidL3NodeList.count {
                        for i in 0 ..< droidL3NodeList.count {
                            let droidL3Node: XMLNode = droidL3NodeList[i]
                            guard 
                                let droidL3Element = droidL3Node as? XMLElement, 
                                // <item/>, <item>…</item>
                                let value = droidL3Element.stringValue
                                else { continue }
                            if isBaseLanguage { 
                                recordList[i].base_value = value
                            } else {
                                recordList[i].lang_value_droid = value
                                recordList[i].lang_value_apple = value                              
                            }
                            recordList[i].sequence = i
                        }
                    } else {
                        print(":ERROR: \(name) array size mismatch")
                    }
                } else { fatalError() }
                tsvVarietyRecords[androidKey] = recordList
                
            } else if name.hasPrefix("food_videos_")  {
                // VARIETY: video topic url component
                let androidKey = String(name.dropFirst("food_videos_".count))
                let iphoneKey = mapDozeDetailsKeys[androidKey]! + "VarietyTopic"
                var recordList = tsvVarietyRecords[androidKey]!
                if let droidL3NodeList = droidL2Element.children {
                    if recordList.count == 0 {
                        recordList = [DozeDetailsTsvVarietyRecord](repeating: DozeDetailsTsvVarietyRecord(androidKey: name, iphoneKey: iphoneKey), count: droidL3NodeList.count)
                    }
                    
                    if recordList.count == droidL3NodeList.count {
                        for i in 0 ..< droidL3NodeList.count {
                            let droidL3Node: XMLNode = droidL3NodeList[i]
                            guard 
                                let droidL3Element = droidL3Node as? XMLElement, 
                                // <item/>, <item>…</item>
                                let value = droidL3Element.stringValue
                                else { continue }
                            if isBaseLanguage { 
                                recordList[i].base_topic = value
                            } else {
                                recordList[i].lang_topic_droid = value
                                recordList[i].lang_topic_apple = value                              
                            }
                            recordList[i].sequence = i
                        }
                    } else {
                        print(":ERROR: \(name) array size mismatch")
                    }
                } else { fatalError() }
                tsvVarietyRecords[androidKey] = recordList
                
            } else if name.hasPrefix("food_info_videos_")  {
                // MAIN: url topic
                // <string-array name="food_videos_beans" translatable="false">
                // URL Topics
                let androidKey = String(name.dropFirst("food_info_videos_".count))
                guard 
                    var record = tsvMainRecords[androidKey] 
                    else {
                        print(":ERROR: \(name) tsvMainRecords[\(androidKey)] not found")
                        continue
                }
                if isBaseLanguage {
                    record.base_topic = droidL2Node.stringValue!
                } else {
                    record.lang_topic_droid = droidL2Node.stringValue!
                    record.lang_topic_apple = droidL2Node.stringValue!
                }                
                tsvMainRecords[androidKey] = record
                
            } else if mapDozeDetailsKeys[name] != nil {
                // MAIN: heading
                let androidKey = name
                var record = tsvMainRecords[androidKey]!
                if isBaseLanguage {
                    record.base_value = droidL2Node.stringValue!
                } else {
                    record.lang_value_droid = droidL2Node.stringValue!
                    record.lang_value_apple = droidL2Node.stringValue!
                }                
                tsvMainRecords[androidKey] = record
            }
            
        }
        cleanPercentS()
    }
    
    private mutating func cleanPercentS() {
        for key in tsvServingRecords.keys {
            guard var servingsList = tsvServingRecords[key] else { continue }
            for i in 0 ..< servingsList.count {
                var r = servingsList[i]
                r.base_imperial = r.base_imperial.replacingOccurrences(of: "%s", with: "")
                r.lang_imperial_droid = r.lang_imperial_droid.replacingOccurrences(of: "%s", with: "")
                r.lang_imperial_apple = r.lang_imperial_apple.replacingOccurrences(of: "%s", with: "")
                r.base_metric = r.base_metric.replacingOccurrences(of: "%s", with: "")
                r.lang_metric_droid = r.lang_metric_droid.replacingOccurrences(of: "%s", with: "")
                r.lang_metric_apple = r.lang_metric_apple.replacingOccurrences(of: "%s", with: "")
                servingsList[i] = r
            }
            tsvServingRecords[key] = servingsList
        }
    }
    
    
    private mutating func convertAndroid2TsvRecords() {
        tsvMainRecords = [String: DozeDetailsTsvMainRecord]()
        tsvServingRecords = [String: [DozeDetailsTsvServingRecord]]()
        tsvVarietyRecords = [String: [DozeDetailsTsvVarietyRecord]]()
        
        for key in mapDozeDetailsKeys.keys {
            let androidBase = androidBaseRecords[key]!
            let androidLang = androidLangRecords[key]!
            let iphoneKey = mapDozeDetailsKeys[key]!
            
            // MAIN
            var mainRecord = DozeDetailsTsvMainRecord(
                androidKey: key,
                iphoneKey: iphoneKey
            )
            mainRecord.base_value = androidBase.heading
            mainRecord.lang_value_droid = androidLang.heading
            mainRecord.lang_value_apple = androidLang.heading
            
            mainRecord.base_topic = androidBase.topic
            mainRecord.lang_topic_droid = androidBase.topic
            mainRecord.lang_topic_apple = androidBase.topic
            
            tsvMainRecords[key] = mainRecord
            
            // SERVINGS
            var servings = [DozeDetailsTsvServingRecord]()
            for i in 0 ..< androidBase.servings.count {
                let baseRecord = androidBase.servings[i]
                let langRecord = androidLang.servings[i]
                
                var record = DozeDetailsTsvServingRecord(androidKey: key, iphoneKey: iphoneKey)
                record.sequence = i + 1
                record.base_imperial = baseRecord.imperial
                record.lang_imperial_droid = langRecord.imperial
                record.lang_imperial_apple = langRecord.imperial
                record.base_metric = baseRecord.metric
                record.lang_metric_droid = langRecord.metric
                record.lang_metric_apple = langRecord.metric
                servings.append(record)
            }
            tsvServingRecords[key] = servings
            
            // VARIETIES
            var varieties = [DozeDetailsTsvVarietyRecord]()
            for i in 0 ..< androidBase.varieties.count {
                let baseRecord = androidBase.varieties[i]
                let langRecord = androidLang.varieties[i]
                
                var record = DozeDetailsTsvVarietyRecord(androidKey: key, iphoneKey: iphoneKey)
                record.sequence = i + 1
                record.base_value = baseRecord.text
                record.lang_value_droid = langRecord.text
                record.lang_value_apple = langRecord.text
                record.base_topic = baseRecord.topic
                record.lang_topic_droid = langRecord.topic
                record.lang_topic_apple = langRecord.topic
                varieties.append(record)
            }
            tsvVarietyRecords[key] = varieties
        }
    }
    
    /// in target language
    func convertAndroid2iPhone() -> DozeDetailInfo {
        var dozeDetailsInfo = DozeDetailInfo()
        
        for key in tsvMainRecords.keys {
            let android = androidLangRecords[key]!
            
            var item = DozeDetailInfo.Item()
            item.heading = android.heading
            item.topic = android.topic
            var servings = [DozeDetailInfo.Item.Serving]()
            for s in android.servings {
                let imperial = s.text.replacingOccurrences(of: "%s", with: s.imperial)
                let metric = s.text.replacingOccurrences(of: "%s", with: s.metric)                
                servings.append(DozeDetailInfo.Item.Serving(imperial: imperial, metric: metric))
            }
            
            var varieties = [DozeDetailInfo.Item.Variety]()
            for v in android.varieties {
                varieties.append(DozeDetailInfo.Item.Variety(text: v.text, topic: v.topic))
            }
            dozeDetailsInfo.itemsDict[key] = item
        }
        return dozeDetailsInfo
    }
    
    func toStringJson() -> String {
        var dozeDetailsInfo = DozeDetailInfo()
        
        for androidKey in tsvMainRecords.keys {
            let iphoneKey = mapDozeDetailsKeys[androidKey]!
            let tsvMain = tsvMainRecords[androidKey]!
            let tsvServings = tsvServingRecords[androidKey]!
            let tsvVarieties = tsvVarietyRecords[androidKey]!
            
            var item = DozeDetailInfo.Item()
            item.heading = tsvMain.base_value
            item.topic = tsvMain.base_topic
            
            var servings = [DozeDetailInfo.Item.Serving]()
            for s in tsvServings {
                servings.append(DozeDetailInfo.Item.Serving(
                    imperial: s.lang_imperial_apple, 
                    metric: s.lang_metric_apple)
                )
            }
            item.servings = servings
            
            var varieties = [DozeDetailInfo.Item.Variety]()
            for v in tsvVarieties {
                varieties.append(DozeDetailInfo.Item.Variety(
                    text: v.lang_value_apple, 
                    topic: v.lang_topic_apple)
                )
            }
            item.varieties = varieties
            
            dozeDetailsInfo.itemsDict[iphoneKey] = item
        }
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.prettyPrinted]
        jsonEncoder.outputFormatting.insert(.sortedKeys)
        
        let jsonData = try! jsonEncoder.encode(dozeDetailsInfo)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
    
    func toStringTsv() -> String {
        var str = DozeDetailsTsvMainRecord.toStringTsvHeader() + "\n"
        for tsv in tsvMainRecords {
            str.append(tsv.value.toStringTsv() + "\n")
        }
        
        for key in tsvServingRecords.keys {
            let servings = tsvServingRecords[key]!
            for s in servings {
                str.append(s.toStringTsv() + "\n")
            }
        }
        
        for key in tsvVarietyRecords.keys {
            let varieties = tsvVarietyRecords[key]!
            for v in varieties {
                str.append(v.toStringTsv() + "\n")
            }
        }
        
        return str
    }
    
    func toStringTsv_WAS() -> (main: String, serving: String, variety: String) { // :!!!:WAS:
        var mainStr = DozeDetailsTsvMainRecord.toStringTsvHeader() + "\n"
        for tsv in tsvMainRecords {
            mainStr.append(tsv.value.toStringTsv() + "\n")
        }
        
        var servingStr = DozeDetailsTsvServingRecord.toStringTsvHeader() + "\n"
        for key in tsvServingRecords.keys {
            let servings = tsvServingRecords[key]!
            for s in servings {
                servingStr.append(s.toStringTsv() + "\n")
            }
        }
        
        var varietyStr = DozeDetailsTsvVarietyRecord.toStringTsvHeader() + "\n"
        for key in tsvVarietyRecords.keys {
            let varieties = tsvVarietyRecords[key]!
            for v in varieties {
                varietyStr.append(v.toStringTsv() + "\n")
            }
        }
        
        return (mainStr, servingStr, varietyStr)
    }
    
    func writeJson(url: URL) {
        let json = self.toStringJson()
        try! json.write(to: url, atomically: false, encoding: String.Encoding.utf8)
    }
    
    /// write.
    func writeTsv(url: URL) {
        let tsv = self.toStringTsv()        
        try! tsv.write(to: url, atomically: false, encoding: String.Encoding.utf8)
    }
    
}
