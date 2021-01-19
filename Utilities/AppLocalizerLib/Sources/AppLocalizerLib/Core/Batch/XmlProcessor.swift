//
//  XmlProcessor.swift
//  AppLocalizerLib
//
//

import Foundation

struct XmlProcessor {

    private var _lookupTableDroid: [String: String] // key_droid, value
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
        
    mutating func process(
        droidXmlUrl: URL, 
        droidXmlDocument: XMLDocument, 
        droidRootXMLElement: XMLElement
    ) {
        // Generate and save expected keys
        keysDroidXmlAll = Set<String>()
        queryAllDriodXmlKeys(node: droidRootXMLElement)
        let keysDroidXmlAllString = keysDroidXmlAll.joined(separator: "\n")
        do {
            let url = droidXmlUrl
                .deletingLastPathComponent()
                .appendingPathComponent("keysExpectedXml_\(Date.datestampyyyyMMddHHmm).txt")
            try keysDroidXmlAllString.write(to: url, atomically: true, encoding: .utf8)
        } catch { print(error) }
        // Process XML File          
        keysDroidXmlMatched = Set<String>()
        processNodeDroidImport(node: droidRootXMLElement)
        
        let options: XMLNode.Options = [.nodePreserveAll, .nodePrettyPrint, .nodePreserveWhitespace]
        let droidXmlData = droidXmlDocument.xmlData(options: options)
        
        let outputUrl = droidXmlUrl
            .deletingPathExtension()
            .appendingPathExtension("\(Date.datestampyyyyMMddHHmm).xml")  
        print(outputUrl.absoluteURL)
        do {
            try droidXmlData.write(to: outputUrl, options: [.atomic])
        } catch {
            print("Could not write document out…\n  …url=\(outputUrl)\n  …error='\(error)'")
        }
    }
    
    mutating func processNodeDroidImport(node :XMLNode) {
        
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
            switch name {
            case "string":
                if let value = _lookupTableDroid[keyId] {
                    node.stringValue = value
                    keysDroidXmlMatched.insert(keyId)
                } else {
                    keysDroidXmlUnmatched.insert(keyId)
                }
            case "string-array":
                for i in 0 ..< children.count {
                    let id = "\(keyId).\(i)"
                    if let value = _lookupTableDroid[id] {
                        node.stringValue = value
                        keysDroidXmlMatched.insert(id)
                    } else {
                        keysDroidXmlUnmatched.insert(id)
                    }                    
                }
            default:
                break
            }            
        } else if let children = node.children {
            for node: XMLNode in children {
                processNodeDroidImport(node: node)
            }
        }
    }

    mutating func queryAllDriodXmlKeys(node :XMLNode) {
        if let name = node.name, 
           let children = node.children, // has children
           let element = node as? XMLElement,
           let keyId = element.attribute(forName: "name")?.stringValue {
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
    
    // MARK: - Normalize Keys

    func normalizeAndroidKey(_ key: String) -> String {
        var key = key
        
        return key
    }

    // MARK: - Watch

}
