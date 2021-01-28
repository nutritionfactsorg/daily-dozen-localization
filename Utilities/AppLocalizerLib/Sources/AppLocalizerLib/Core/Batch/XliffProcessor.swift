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
        let randomStatedStrings = String.randomStatedJoinedStrings(list: keysAppleXliffAll.sorted())
        let keysExpectedString = randomStatedStrings.stated + "----- RANDOM XLIFF KEYS -----" + randomStatedStrings.random
        
        do {
            let url = appleXmlUrl
                .deletingLastPathComponent()
                .appendingPathComponent("keysExpectedXliff_\(Date.datestampyyyyMMddHHmm).txt")
            try keysExpectedString.write(to: url, atomically: true, encoding: .utf8)
        } catch { print(error) }
        // Process XLIFF XML File
        keysAppleXliffMatched = Set<String>()
        processNodeAppleImport(element: appleRootXMLElement)
        
        // XMLDocument(contentsOf: URL, options: XMLNode.Options)
        //      someXmlDocument.xmlData(options: XMLNode.Options)
        
        let options: XMLNode.Options = [.nodePreserveAll, .nodePrettyPrint]
        let appleXmlData = appleXmlDocument.xmlData(options: options)
        guard var appleXmlStr = String(data: appleXmlData, encoding: String.Encoding.utf8) else { return }
        appleXmlStr = appleXmlStr.replacingOccurrences(of: "    ", with: "  ")
        
        let outputUrl = appleXmlUrl
            .deletingPathExtension()
            .appendingPathExtension("\(Date.datestampyyyyMMddHHmm).xliff")  
        print(outputUrl.absoluteURL)
        do {
            try appleXmlStr.write(to: outputUrl, atomically: true, encoding: .utf8)
        } catch {
            print("Could not write document out…\n  …url=\(outputUrl)\n  …error='\(error)'")
        }
    }
    
    mutating func processNodeAppleImport(element :XMLElement) {
        //print(node.toStringNode())
        if let name = element.name, 
           name == "trans-unit", 
           let children = element.children,
           var id = element.attribute(forName: "id")?.stringValue
        {
            id = normalizeAppleKey(id)
            var targetNodeFound = false
            for childNode in children {
                guard let childName = childNode.name else { continue }
                // child nodes "source" and "note" are not used here.
                if childName == "target" {
                    if let targetValue = _lookupTableApple[id] {
                        childNode.stringValue = targetValue
                        keysAppleXliffMatched.insert(id)
                    } else {
                        keysAppleXliffUnmatched.insert(id)
                    }
                    targetNodeFound = true
                }
            }
            if targetNodeFound == false {
                let newTargetNode = XMLElement()
                newTargetNode.name = "target"
                if let targetValue = _lookupTableApple[id] {
                    newTargetNode.stringValue = targetValue
                    element.insertChild(newTargetNode, at: 1)
                    keysAppleXliffMatched.insert(id)
                } else {
                    keysAppleXliffUnmatched.insert(id)
                }
            }
        } else if let children = element.children {
            for element in children where element is XMLElement {
                processNodeAppleImport(element: element as! XMLElement)
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
