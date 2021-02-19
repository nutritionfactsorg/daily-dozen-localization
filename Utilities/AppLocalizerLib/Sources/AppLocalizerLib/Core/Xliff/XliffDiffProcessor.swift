//
//  XliffDiffProcessor.swift
//  AppLocalizerLib
//

import Foundation

struct XliffDiffProcessor {

    var urlAa: URL
    var urlBb: URL
    //
    var rootAa: XMLElement!
    var rootBb: XMLElement!

    init(a: URL, b: URL) {
        urlAa = a
        urlBb = b
        guard 
            let docAa = try? XMLDocument(contentsOf: a, options: .nodePreserveAll),
            let docBb = try? XMLDocument(contentsOf: b, options: .nodePreserveAll),
            let rootAa: XMLElement = docAa.rootElement(),
            let rootBb: XMLElement = docBb.rootElement()
        else { return }
        self.rootAa = rootAa
        self.rootBb = rootBb
    }
    
    func doDiffKeys() {  
        var keysAa = Set<String>()
        var keysBb = Set<String>()

        getKeySet(element: rootAa, result: &keysAa)
        getKeySet(element: rootBb, result: &keysBb)
        
        let onlyInA = keysAa.subtracting(keysBb)
        let onlyInB = keysBb.subtracting(keysAa)
        printKeyDiff(onlyInA: onlyInA, onlyInB: onlyInB) 
    }
    
    private func getKeySet(element: XMLElement, result: inout Set<String>) {
        //print(node.toStringNode())
        if let name = element.name,
           name == "trans-unit",
           let _ = element.children, // has children
           let keyId = element.attribute(forName: "id")?.stringValue
        {
            result.insert(keyId)
        } else if let children = element.children {
            for element in children where element is XMLElement {
                getKeySet(element: element as! XMLElement, result: &result)
            }
        }
    }

    private func getRowList(element: XMLElement, result: inout Array<TsvRow>) {
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
            result.append(newRow)
        } else if let children = element.children {
            for element in children where element is XMLElement {
                getRowList(element: element as! XMLElement, result: &result)
            }
        }
    }
    
    private func printKeyDiff(onlyInA: Set<String>, onlyInB: Set<String>) {
        let onlyInAList = Array(onlyInA).sorted()
        let onlyInBList = Array(onlyInB).sorted()
        
        var s = 
            """
            ****************
            ***** DIFF *****
            ****************
            ** A: \(urlAa.path)  
            ** B: \(urlBb.path)  
            *****
            *** A Unique\n
            """
        for id in onlyInAList {
            s.append("\(id)\n")
        }
        s.append(
            """
            *****
            *** B Unique\n
            """
        )
        for id in onlyInBList {
            s.append("\(id)\n")
        }
        s.append(
            """
            *****
            """
        )
        print(s)
    }

}
