//
//  XmlFromTsvProcessor.swift
//  AppLocalizerLib
//
//

import Foundation

/// XmlFromTsvProcessor updates an exsiting Android XML structure from provided TSV data 
struct XmlFromTsvProcessor {
    
    /// [key_droid, lang_value] from _tsvImportSheet
    private var _lookupTableDroid: [String: String] 
    var keysDroidXmlAll = Set<String>() // key_droid
    var keysDroidXmlMatched = Set<String>()
    var keysDroidXmlUnmatched = Set<String>()
        
    init(lookupTable: [String: String]) {
        _lookupTableDroid = lookupTable
    }
    
    mutating func clearAll() {
        _lookupTableDroid = [String: String]() // key_droid, value
        keysDroidXmlAll = Set<String>() // key_droid
        keysDroidXmlMatched = Set<String>()
        keysDroidXmlUnmatched = Set<String>()
    }
    
    // modifies XML document given a TSV document to apply
    mutating func processXmlFromTsv(
        droidXmlOutputUrl: URL, 
        droidXmlDocument: XMLDocument, 
        measurementInDescription: Bool = false
    ) {
        guard let droidRootXMLElement = droidXmlDocument.rootElement() else { return }
        
        if measurementInDescription {
            // normalize/reduce %s in static imperial & metric strings XML
            measureDescriptionMerge(xmlDoc: droidXmlDocument)
        } else {
            // augment TSV to support %s description with separate imperial & metric measurements 
            measureDescriptionSplit()
        }
        
        // Create directory path if needed
        let fm = FileManager.default
        try? fm.createDirectory(at: droidXmlOutputUrl.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        
        // Generate and save expected keys
        keysDroidXmlAll = Set<String>()
        queryAllDriodXmlKeys(node: droidRootXMLElement)
        let keysDroidXmlAllString = keysDroidXmlAll.sorted().joined(separator: "\n")
        do {
            let url = droidXmlOutputUrl
                .deletingLastPathComponent()
                .appendingPathComponent("keysExpectedXml_\(Date.datestampyyyyMMddHHmm).txt")
            try keysDroidXmlAllString.write(to: url, atomically: true, encoding: .utf8)
        } catch { print(error) }
        
        // Apply TSV to XML File          
        keysDroidXmlMatched = Set<String>()
        processXmlFromTsv(node: droidRootXMLElement)
        
        // Write updated XML file        
        let options: XMLNode.Options = [.nodePreserveAll, .nodePrettyPrint, .nodePreserveWhitespace]
        let droidXmlData = droidXmlDocument.xmlData(options: options)
        do {
            try droidXmlData.write(to: droidXmlOutputUrl, options: [.atomic])
        } catch {
            print("Could not write document out…\n  …url=\(droidXmlOutputUrl)\n  …error='\(error)'")
        }
    }
    
    mutating func processXmlFromTsv(node :XMLNode) {
        
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
           var keyId = element.attribute(forName: "name")?.stringValue {
            keyId = normalizeAndroidKey(keyId)
            if watched(keyId) {
                print(":WATCH: \(keyId)")
                print("- - - - - - - - -")
            }
            if let translatable = element.attribute(forName: "translatable"),
               translatable.stringValue?.lowercased() == "false" {
                return // do not process translatable="false" elements
            }
            if XmlRemap.check.isDropped(keyId) {
                return // skipped element
            }
            switch name {
            case "string":
                if let value = _lookupTableDroid[keyId] {
                    node.stringValue = value
                    keysDroidXmlMatched.insert(keyId)
                } else {
                    //print(":DEBUG: keyId=\(keyId)")
                    keysDroidXmlUnmatched.insert(keyId)
                }
            case "string-array":
                for i in 0 ..< children.count {
                    let keyIdIndexed = "\(keyId).\(i)" // fully specified
                    if let child = element.child(at: i) {
                        if let value = _lookupTableDroid[keyIdIndexed] {
                            child.stringValue = value
                            keysDroidXmlMatched.insert(keyIdIndexed)
                        } else {
                            //print(":DEBUG: keyIdIndexed=\(keyIdIndexed)")
                            keysDroidXmlUnmatched.insert(keyIdIndexed)
                        }
                    }
                }
            default:
                break
            }            
        } else if let children = node.children {
            for node: XMLNode in children {
                processXmlFromTsv(node: node)
            }
        }
    }
    
    mutating func queryAllDriodXmlKeys(node :XMLNode) {
        if let name = node.name, 
           let children = node.children, // has children
           let element = node as? XMLElement,
           let keyId = element.attribute(forName: "name")?.stringValue {
            if let translatable = element.attribute(forName: "translatable"),
               translatable.stringValue?.lowercased() == "false" {
                return // do not include translatable="false" elements
            }
            switch name {
            case "string":
                keysDroidXmlAll.insert(keyId)
            case "string-array":
                for i in 0 ..< children.count {
                    keysDroidXmlAll.insert("\(keyId).\(i)")
                }
            default:
                break
            }            
        } else if let children = node.children {
            for node: XMLNode in children {
                queryAllDriodXmlKeys(node: node)
            }
        }
    }
    
    mutating func measureDescriptionSplit() {
        for baseKey in XmlRemap.dozeSet {
            var i = 0
            var imperialKey = "\(baseKey)_imperial.\(i)"
            var metricKey = "\(baseKey)_metric.\(i)"
            while let imperial = _lookupTableDroid[imperialKey],
                  let metric = _lookupTableDroid[metricKey] {
                let parts = measureDescriptionSplit(imperial: imperial, metric: metric)
                let baseKeyIndexed = "\(baseKey).\(i)"
                _lookupTableDroid[baseKeyIndexed] = parts.description
                _lookupTableDroid[imperialKey] = parts.imperialMeasure
                _lookupTableDroid[metricKey] = parts.metricMeasure
                if watched(baseKey) {
                    var s = ":WATCH: \(baseKey)\n"
                    s.append("  [\(baseKeyIndexed)] '\(parts.description)'\n")
                    s.append("  [\(imperialKey)] '\(parts.imperialMeasure)'\n")
                    s.append("  [\(metricKey)] '\(parts.metricMeasure)'\n\n")
                    print(s)
                }
                // next iteration
                i = i + 1
                imperialKey = "\(baseKey)_imperial.\(i)"
                metricKey = "\(baseKey)_metric.\(i)"
            }
        }
    }
    
    /// split string into description with "%s", imperial measurement, and metric measurement 
    func measureDescriptionSplit(imperial: String, metric: String) -> (description: String, imperialMeasure: String, metricMeasure: String) {
        var imperialMeasure = [Character]()
        var metricMeasure = [Character]()
        var description = [Character]()
        
        var imperialArray = [Character]() 
        for c: Character in imperial { imperialArray.append(c) }
        
        var metricArray = [Character]()
        metricArray.append(contentsOf: metric)
        //for c: Character in metric { metricArray.append(c) }
        
        // find common prefix (left side)
        var iLeft = 0
        var mLeft = 0
        while iLeft < imperialArray.count && mLeft < metricArray.count &&
                imperialArray[iLeft] == metricArray[mLeft] {
            description.append(imperialArray[iLeft])
            iLeft = iLeft + 1
            mLeft = mLeft + 1
        }
        
        // find common suffix (right side)
        var iRight = imperialArray.count - 1
        var mRight = metricArray.count - 1
        var descriptionSuffix = [Character]()
        while iRight >= 0 && mRight >= 0 &&
                imperialArray[iRight] == metricArray[mRight] {
            descriptionSuffix.append(imperialArray[iRight])
            iRight = iRight - 1
            mRight = mRight - 1
        }
        
        // assemble common string description with "%s"
        if description.count == imperialArray.count && description.count == metricArray.count {
            description = "%s" + description
        } else if description.count != imperialArray.count && description.count == metricArray.count {
            fatalError("what case is this?")
        } else if description.count == imperialArray.count && description.count != metricArray.count {
            fatalError("what case is this?")
        } else {
            description.append(contentsOf: "%s")
            if descriptionSuffix.count > 0 {
                for i in (0 ... (descriptionSuffix.count - 1)).reversed()  {
                    description.append(descriptionSuffix[i])
                }
            }
        }
        
        if iLeft < iRight {
            // store imperial measurement
            for i in iLeft ... iRight {
                imperialMeasure.append(imperialArray[i])
            }
            
            // store metric measurement
            for m in mLeft ... mRight {
                metricMeasure.append(metricArray[m])
            }
        }
        
        return (String(description), String(imperialMeasure), String(metricMeasure))
    }
    
    /// 
    mutating func measureDescriptionMerge(xmlDoc: XMLDocument) {
        for name in XmlRemap.dozeSet {
            measureDescriptionMerge(xmlDoc: xmlDoc, name: name)
        }
    }
    
    mutating func measureDescriptionMerge(xmlDoc: XMLDocument, name: String) {
        let baseXPath = ".//string-array[@name='\(name)']"
        let imperialXPath = ".//string-array[@name='\(name)_imperial']"
        let metricXPath = ".//string-array[@name='\(name)_metric']"
        guard 
            let baseNodeList: [XMLNode] = try? xmlDoc.nodes(forXPath: baseXPath),
            let imperialNodeList: [XMLNode] = try? xmlDoc.nodes(forXPath: imperialXPath),
            let metricNodeList: [XMLNode] = try? xmlDoc.nodes(forXPath: metricXPath) 
        else { return }
        
        print(baseNodeList)
        print(imperialNodeList)
        print(metricNodeList)
        print("--------------------------------")
        
        guard baseNodeList.count == imperialNodeList.count &&
                baseNodeList.count == metricNodeList.count
        else { return }
        
        for i in 0 ..< baseNodeList.count {
            let baseStr = baseNodeList[i].child(at: i)!.stringValue
            let imperial = imperialNodeList[i].child(at: i)!
            let metric = metricNodeList[i].child(at: i)!
            
            imperial.stringValue = baseStr?.replacingOccurrences(of: "%s", with: imperial.stringValue!)
            metric.stringValue = baseStr?.replacingOccurrences(of: "%s", with: metric.stringValue!)
            print(imperial.stringValue!)
            print(metric.stringValue!)
            print("==================")
        }
        fatalError("not implemented")
        // implementation of this approach would `.detach()` the base node and keep imperial and metric nodes as fully expanded descriptions 
    }
    
    
    // MARK: - Normalize Keys
    
    func normalizeAndroidKey(_ key: String) -> String {
        let key = key
        
        return key
    }
    
    // MARK: - Watch
    
    func watched(_ s: String) -> Bool {
        // "some_key_base" || "NO_WATCH"
        // "food_info_serving_sizes_beans"
        // "food_info_serving_sizes_spices"
        if s.hasPrefix("NO_WATCH") {
            return true
        }
        return false
    }
}
