//
//  XmlIntoTsvProcessor.swift
//  AppLocalizerLib
//

import Foundation

/// XmlIntoTsvProcessor converts Android XML (strings.xml) data into TSV data
struct XmlIntoTsvProcessor: TsvProtocol {
    
    var tsvRowList = TsvRowList() /// [key_droid: TsvRow]
    
    init(url: URL, baseOrLang: TsvBaseOrLangMode) {
        guard 
            let xmlDoc = try? XMLDocument(contentsOf: url, options: [.nodePreserveAll, .nodePreserveWhitespace]),
            let rootXmlElement: XMLElement = xmlDoc.rootElement()
        else { return }
        processXmlIntoTsv(node: rootXmlElement, baseOrLang: baseOrLang)
        postProcessDoze(baseOrLang: baseOrLang)     
    }

    mutating func processXmlIntoTsv(node :XMLNode, baseOrLang: TsvBaseOrLangMode) {
        
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
                if var tsvRow = tsvRowList.get(key: keyId, keyType: .droid) { 
                    // overwrite value
                    switch baseOrLang {
                    case .baseMode:
                        tsvRow.base_value = value
                    case .langMode:
                        tsvRow.lang_value = value
                    }
                    tsvRowList.putRowValues(key: keyId, keyType: .droid, row: tsvRow)
                } else {
                    let newRow = TsvRow(
                        key_android: keyId, 
                        key_apple: "", 
                        base_value: baseOrLang == .baseMode ? value : "", 
                        lang_value: baseOrLang == .baseMode ? "": value, 
                        base_note: ""
                    )
                    tsvRowList.putRowValues(key: keyId, keyType: .droid, row: newRow)
                }
            case "string-array":
                for i in 0 ..< children.count {
                    let keyNumberedId = "\(keyId).\(i)" // fully specified
                    if let child = element.child(at: i) {
                        let value = child.stringValue ?? ""
                        if var tsvRow = tsvRowList.get(key: keyNumberedId, keyType: .droid) {
                            // overwrite value
                            switch baseOrLang {
                            case .baseMode:
                                tsvRow.base_value = value
                            case .langMode:
                                tsvRow.lang_value = value
                            }   
                            tsvRowList.putRowValues(key: keyNumberedId, keyType: .droid, row: tsvRow)
                        } else {
                            let newRow = TsvRow(
                                key_android: keyNumberedId, 
                                key_apple: "", 
                                base_value: baseOrLang == .baseMode ? value : "", 
                                lang_value: baseOrLang == .baseMode ? "": value, 
                                base_note: ""
                            )
                            tsvRowList.putRowValues(key: keyNumberedId, keyType: .droid, row: newRow)
                        }
                    }
                }
            default:
                break
            }            
        } else if let children = node.children {
            for node: XMLNode in children {
                processXmlIntoTsv(node: node, baseOrLang: baseOrLang)
            }
        }
    }
    
    private mutating func postProcessDoze(baseOrLang: TsvBaseOrLangMode) {
        for name in XmlRemap.dozeSet {
            
            var idx = 0
            var notDone = true
            while notDone {

                let baseId = "\(name).\(idx)"
                let imperialId = "\(name)_imperial.\(idx)"
                let metricId = "\(name)_metric.\(idx)"
                
                guard
                    // :BYE: tsvRowDict[baseId]
                    let baseTsvRow = tsvRowList.get(key: baseId, keyType: .droid),
                    var imperialTsvRow = tsvRowList.get(key: imperialId, keyType: .droid),
                    var metricTsvRow = tsvRowList.get(key: metricId, keyType: .droid)
                else {
                    notDone = false 
                    continue
                }
                
                switch baseOrLang {
                case .baseMode:
                    imperialTsvRow.base_value = baseTsvRow.base_value
                        .replacingOccurrences(of: "%s", with: imperialTsvRow.base_value)
                    metricTsvRow.base_value = baseTsvRow.base_value
                        .replacingOccurrences(of: "%s", with: metricTsvRow.base_value)
                case .langMode:
                    imperialTsvRow.lang_value = baseTsvRow.lang_value
                        .replacingOccurrences(of: "%s", with: imperialTsvRow.lang_value)
                    metricTsvRow.lang_value = baseTsvRow.lang_value
                        .replacingOccurrences(of: "%s", with: metricTsvRow.lang_value)
                }
                
                tsvRowList.remove(key: baseId, keyType: .droid)
                
                idx = idx + 1
            }
            
        }
        
    }
    
    // MARK: - Operations
    
    // no TsvProtocol Operations overrides
    
    // MARK: - Output
    
    // no TsvProtocol Output overrides
    
}
