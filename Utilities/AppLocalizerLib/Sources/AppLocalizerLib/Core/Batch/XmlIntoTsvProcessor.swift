//
//  XmlIntoTsvProcessor.swift
//  AppLocalizerLib
//

import Foundation

/// XmlIntoTsvProcessor converts Android XML (strings.xml) data into TSV data
struct XmlIntoTsvProcessor {
    
    var tsvRowDict = [String: TsvRow]() /// [key_droid: TsvRow]
    
    init(url: URL, isBaseLanguage isBase: Bool) {
        guard 
            let xmlDoc = try? XMLDocument(contentsOf: url, options: [.nodePreserveAll, .nodePreserveWhitespace]),
            let rootXmlElement: XMLElement = xmlDoc.rootElement()
        else { return }
        processXmlIntoTsv(node: rootXmlElement, isBaseLanguage: isBase)
        postProcessDoze(isBaseLanguage: isBase)        
    }

    mutating func processXmlIntoTsv(node :XMLNode, isBaseLanguage isBase: Bool) {
        
        //if node.children != nil {
        //    print(node.toStringNode())
        //} else {
        //    // kind:element name:'string'
        //    // kind:element name:'string-array'
        //    // kind:element name:'integer-array' food_quantities, tweak_amounts
        //    // kind:comment name:'nil'
        //    print(node.toStringNode())  
        //}
        
        if let name = node.name, 
           let children = node.children, // has children
           let element = node as? XMLElement,
           let keyId = element.attribute(forName: "name")?.stringValue {
            //keyId = normalizeAndroidKey(keyId)
            //if watched(keyId) {
            //    print(":WATCH: \(keyId)")
            //    print("- - - - - - - - -")
            //}
            if let translatable = element.attribute(forName: "translatable"),
               translatable.stringValue?.lowercased() == "false" {
                return // do not process translatable="false" elements
            }
            if XmlRemap.check.isDropped(keyId) {
                return // skipped element
            }
            switch name {
            case "string":
                let value = node.stringValue ?? ""
                if var tsvRow = tsvRowDict[keyId] {
                    // overwrite value
                    if isBase {
                        tsvRow.base_value = value
                    } else {
                        tsvRow.lang_value = value
                    }
                    tsvRowDict[keyId] = tsvRow
                } else {
                    tsvRowDict[keyId] = TsvRow(
                        key_android: keyId, 
                        key_apple: "", 
                        base_value: isBase ? value : "", 
                        lang_value: isBase ? "": value, 
                        comments: ""
                    )
                }
            case "string-array":
                for i in 0 ..< children.count {
                    let keyNumberedId = "\(keyId).\(i)" // fully specified
                    if let child = element.child(at: i) {
                        let value = child.stringValue ?? ""
                        if var tsvRow = tsvRowDict[keyNumberedId] {
                            // overwrite value
                            if isBase {
                                tsvRow.base_value = value
                            } else {
                                tsvRow.lang_value = value
                            }
                            tsvRowDict[keyNumberedId] = tsvRow
                        } else {
                            tsvRowDict[keyNumberedId] = TsvRow(
                                key_android: keyNumberedId, 
                                key_apple: "", 
                                base_value: isBase ? value : "", 
                                lang_value: isBase ? "": value, 
                                comments: ""
                            )
                        }
                    }
                }
            default:
                break
            }            
        } else if let children = node.children {
            for node: XMLNode in children {
                processXmlIntoTsv(node: node, isBaseLanguage: isBase)
            }
        }
    }
    
    private mutating func postProcessDoze(isBaseLanguage isBase: Bool) {
        for name in XmlRemap.dozeSet {
            
            var idx = 0
            var notDone = true
            while notDone {

                let baseId = "\(name).\(idx)"
                let imperialId = "\(name)_imperial.\(idx)"
                let metricId = "\(name)_metric.\(idx)"
                
                guard
                    let baseTsvRow = tsvRowDict[baseId],
                    var imperialTsvRow = tsvRowDict[imperialId],
                    var metricTsvRow = tsvRowDict[metricId]
                else {
                    notDone = false 
                    continue
                }
                
                if isBase {
                    imperialTsvRow.base_value = baseTsvRow.base_value
                        .replacingOccurrences(of: "%s", with: imperialTsvRow.base_value)
                    metricTsvRow.base_value = baseTsvRow.base_value
                        .replacingOccurrences(of: "%s", with: metricTsvRow.base_value)
                } else {
                    imperialTsvRow.lang_value = baseTsvRow.lang_value
                        .replacingOccurrences(of: "%s", with: imperialTsvRow.lang_value)
                    metricTsvRow.lang_value = baseTsvRow.lang_value
                        .replacingOccurrences(of: "%s", with: metricTsvRow.lang_value)
                }
                
                tsvRowDict[baseId] = nil
                
                idx = idx + 1
            }
            
        }
        
    }
    
}
