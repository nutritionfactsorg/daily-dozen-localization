//
//  XliffIntoTsvProcessor.swift
//  AppLocalizerLib
//

import Foundation

/// XliffIntoTsvProcessor converts Apple XLIFF data into TSV data
struct XliffIntoTsvProcessor: TsvProtocol {
    
    var tsvRowList = TsvRowList()
    
    init(url: URL) {
        guard 
            let xmlDoc = try? XMLDocument(contentsOf: url, options: [.nodePreserveAll]),
            let rootXmlElement: XMLElement = xmlDoc.rootElement()
        else { return }
        processXliffIntoTsv(element: rootXmlElement)
    }
        
    mutating func processXliffIntoTsv(element :XMLElement) {
        //print(node.toStringNode())
        if let name = element.name,
           name == "trans-unit",
           let children = element.children,
           let keyId = element.attribute(forName: "id")?.stringValue
        {
            var sourceValue = ""
            var targetValue = ""
            var noteValue = ""
            for childNode in children {
                guard let childName = childNode.name else { continue }
                switch childName {
                case "source":
                    sourceValue = childNode.stringValue ?? ""
                case "target":
                    targetValue = childNode.stringValue ?? ""              
                case "note":
                    noteValue = childNode.stringValue ?? ""
                default:
                    break
                }
            }
            let newRow = TsvRow(
                key_android: "", 
                key_apple: keyId, 
                base_value: sourceValue, 
                lang_value: targetValue, 
                note: noteValue
            )
            tsvRowList.putRowValues(key: keyId, keyType: .apple, row: newRow)
        } else if let children = element.children {
            for element in children where element is XMLElement {
                processXliffIntoTsv(element: element as! XMLElement)
            }
        }
    }
    
    // MARK: - Operations
    
    // no TsvProtocol Operations overrides
    
    // MARK: - Output

    // no TsvProtocol Output overrides
    
}
