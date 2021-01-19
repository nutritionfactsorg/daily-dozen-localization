//
//  XliffProcessor.swift
//  AppLocalizerLib
//
//

import Foundation

struct XliffProcessor {
    
    private var _lookupTableApple = [String: String]() // key_apple, value

    var keysAppleXliffAll = Set<String>() // key_apple
    var keysAppleXliffMatched = Set<String>()
    var keysAppleXliffUnmatched = Set<String>()

    init(lookupTable: [String: String]) {
        _lookupTableApple = lookupTable
    }
    
    mutating func clearAll() {
        _lookupTableApple = [String: String]() // key_droid, value
        keysAppleXliffAll = Set<String>() // key_droid
        keysAppleXliffMatched = Set<String>()
        keysAppleXliffUnmatched = Set<String>()
    }
    
    mutating func process(
        appleXmlUrl: URL, 
        appleXmlDocument: XMLDocument, 
        appleRootXMLElement: XMLElement
    ) {
        // Generate and save expected keys
        keysAppleXliffAll = Set<String>()
        queryAllAppleXliffKeys(node: appleRootXMLElement)
        let keysExpectedString = keysAppleXliffAll.joined(separator: "\n")
        do {
            let url = appleXmlUrl
                .deletingLastPathComponent()
                .appendingPathComponent("keysExpectedXliff_\(Date.datestampyyyyMMddHHmm).txt")
            try keysExpectedString.write(to: url, atomically: true, encoding: .utf8)
        } catch { print(error) }
        // Process XLIFF XML File
        keysAppleXliffMatched = Set<String>()
        processNodeAppleImport(node: appleRootXMLElement)
        
        // XMLDocument(contentsOf: URL, options: XMLNode.Options)
        //      someXmlDocument.xmlData(options: XMLNode.Options)
        
        let options: XMLNode.Options = [.nodePreserveAll, .nodePrettyPrint]
        let appleXmlData = appleXmlDocument.xmlData(options: options)
        
        let outputUrl = appleXmlUrl
            .deletingPathExtension()
            .appendingPathExtension("\(Date.datestampyyyyMMddHHmm).xliff")  
        print(outputUrl.absoluteURL)
        do {
            try appleXmlData.write(to: outputUrl, options: [.atomic])
        } catch {
            print("Could not write document out…\n  …url=\(outputUrl)\n  …error='\(error)'")
        }
    }
    
    mutating func processNodeAppleImport(node :XMLNode) {
        //print(node.toStringNode())
        if let name = node.name, 
           name == "trans-unit", 
           let children = node.children,
           let element = node as? XMLElement,
           var id = element.attribute(forName: "id")?.stringValue
        {
            //var sourceNode: XMLNode!
            var targetNode: XMLNode!
            //var noteNode: XMLNode!
            for child in children {
                guard let childname = child.name else { continue }
                switch childname {
                case "source":
                    //sourceNode = child
                    break
                case "target":
                    targetNode = child
                    id = normalizeAppleKey(id)
                    if let value = _lookupTableApple[id] {
                        targetNode.stringValue = value
                        keysAppleXliffMatched.insert(id)
                    } else {
                        keysAppleXliffUnmatched.insert(id)
                    }
                case "note":
                    //noteNode = child
                    break
                default:
                    break
                }
            }
        } else if let children = node.children {
            for node: XMLNode in children {
                processNodeAppleImport(node: node)
            }
        }
    }

    
    mutating func queryAllAppleXliffKeys(node :XMLNode) {
        if let name = node.name, 
           name == "trans-unit", 
           let element = node as? XMLElement,
           let id = element.attribute(forName: "id")?.stringValue
        {
            keysAppleXliffAll.insert(id)
        } else if let children = node.children {
            for node: XMLNode in children {
                queryAllAppleXliffKeys(node: node)
            }
        }
    }
    
    // MARK: - Normalize Keys

    func normalizeAppleKey(_ key: String) -> String {
        var key = key
        
        return key
    }

    // MARK: - Watch


    
}
