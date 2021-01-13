//
//  BatchRunner.swift
//  AppLocalizerLib
//
//  Created by marc on 2020.08.25.
//

import Foundation

struct BatchRunner {
    // Batch Commands File URL
    let commandsUrl: URL
    let languagesUrl: URL
    let mappingsUrl: URL
    // Internal 
    private var _lookupTable = [String: String]()     // key_*, value
    private var _jsonProcessor: JsonProcessor!        // key_apple
    private var _xmlKeysExpectedApple = Set<String>() // key_apple
    private var _xmlKeysExpectedDroid = Set<String>() // key_droid
    private var _xmlKeysProcessed = Set<String>()     // key_*
    private var _xmlKeysNotFound = [String]()
    
    init(commandsUrl: URL, languagesUrl: URL, mappingsUrl: URL) {
        self.commandsUrl = commandsUrl
        self.languagesUrl = languagesUrl
        self.mappingsUrl = mappingsUrl
    }
    
    mutating func run() {
        // Batch Export Parameters
        var inputBaseAndroid: URL?
        var inputBaseApple: URL?
        var inputTargetAndroid: URL?
        var inputTargetApple: URL?
        var outputTSV: URL?
        // Batch Import Parameters
        var inputTSV: URL?
        var outputAndroid: URL?
        var outputApple: URL?
        
        guard let commands = try? String(contentsOf: commandsUrl) else {
            fatalError("could not read commands")
        }
        
        let lines = commands.components(separatedBy: CharacterSet.newlines)
        
        for l in lines {
            guard let cmd = parseLine(l) else { continue }
            
            // Export
            if cmd.key.hasPrefix("INPUT_BASE_ANDROID") {
                inputBaseAndroid = cmd.url
            }
            else if cmd.key.hasPrefix("INPUT_BASE_APPLE") {
                inputBaseApple = cmd.url
            } 
            else if cmd.key.hasPrefix("INPUT_TARGET_ANDROID") {
                inputTargetAndroid = cmd.url
            } 
            else if cmd.key.hasPrefix("INPUT_TARGET_APPLE") {
                inputTargetApple = cmd.url
            } 
            else if cmd.key.hasPrefix("OUTPUT_TSV") {
                outputTSV = cmd.url
            } 
            else if cmd.key.hasPrefix("DO_EXPORT_TSV") {
                doExport(inputBaseAndroid: inputBaseAndroid, 
                         inputBaseApple: inputBaseApple, 
                         inputTargetAndroid: inputTargetAndroid, 
                         inputTargetApple: inputTargetApple, 
                         outputTSV: outputTSV)
            } 
            // Import
            else if cmd.key.hasPrefix("INPUT_TSV") {
                inputTSV = cmd.url
            } 
            else if cmd.key.hasPrefix("OUTPUT_ANDROID") {
                outputAndroid = cmd.url
            } 
            else if cmd.key.hasPrefix("OUTPUT_APPLE") {
                outputApple = cmd.url
            } 
            else if cmd.key.hasPrefix("DO_IMPORT_TSV") {
                if let inputTSV = inputTSV {
                    doImport(inputTSV: inputTSV, 
                             outputAndroid: outputAndroid, 
                             outputApple: outputApple)
                } else {
                    print(":ERROR: BatchRunner run() missing INPUT_TSV")
                }
            }
            // Quit
            else if cmd.key.hasPrefix("QUIT") {
                return
            }
        }
    }
    
    private func parseLine(_ line: String) -> (key: String, url: URL?)? {
        let line = line.trimmingCharacters(in: CharacterSet.whitespaces)
        if line.isEmpty { return nil }
        if line.prefix(1) == "#" { return nil }
        
        let parts = line.components(separatedBy: "=")
        let cmdKey = parts[0]
            .trimmingCharacters(in: CharacterSet.whitespaces)
            .uppercased()
        var cmdValue = ""
        
        if parts.count == 1 {
            return (cmdKey, nil)
        } 
        else if parts.count == 2 {
            cmdValue = parts[1].trimmingCharacters(in: CharacterSet.whitespaces)
            if (cmdValue.first != "\"") || (cmdValue.last != "\"") {
                print("ERROR:A: Expected double quoted value. Did not process: '\(line)'")
                return nil                    
            }  
            cmdValue = String(parts[1].dropFirst().dropLast())
            if cmdValue.isEmpty {
                return (cmdKey, nil)                
            }
            else {
                let cmdUrl = languagesUrl.appendingPathComponent(cmdValue)
                return (cmdKey, cmdUrl)                
            }
        }
        else { // parts.count > 2
            print("ERROR:B: Too many line `parts`. Did not process: '\(line)'")
            return nil
        }
    } 
    
    func doExport(
        inputBaseAndroid: URL?, 
        inputBaseApple: URL?, 
        inputTargetAndroid: URL?, 
        inputTargetApple: URL?, 
        outputTSV: URL?
    ) {
        print("""
        ### DO_EXPORT_TSV doExport() ###
            inputBaseAndroid = \(inputBaseAndroid?.absoluteString ?? "nil")
              inputBaseApple = \(inputBaseApple?.absoluteString ?? "nil")
          inputTargetAndroid = \(inputTargetAndroid?.absoluteString ?? "nil")
            inputTargetApple = \(inputTargetApple?.absoluteString ?? "nil")
                   outputTSV = \(outputTSV?.absoluteString ?? "nil")
        """)
        
    }
    
    mutating func doImport(
        inputTSV: URL, 
        outputAndroid: URL?, 
        outputApple: URL?
    ) {
        print("""
        ### DO_IMPORT_TSV doImport() ###
               inputTSV = \(inputTSV.absoluteString)
          outputAndroid = \(outputAndroid?.absoluteString ?? "nil")
            outputApple = \(outputApple?.absoluteString ?? "nil")
        """)
        
        // 1. TSV Input File
        let sheet = TsvImportSheet(url: inputTSV, loglevel: .info)
        //print(sheet.toString())    // :DEBUG:
        //print(sheet.toStringDot()) // :DEBUG:
        
        // *. Process Apple JSON Files
        if let appleXmlUrl = outputApple {
            _jsonProcessor = JsonProcessor(xliffUrl: appleXmlUrl, lookupTable: _lookupTable)
            _lookupTable = sheet.getLookupDictApple()
            for r in sheet.getLookupDictApple() {
                if _jsonProcessor.process(key: r.key, value: r.value) {
                    _xmlKeysProcessed.insert(r.key)
                }
            }
            _jsonProcessor.writeJsonFiles()
        }
        
        // 2. Process Apple XMLDocument
        if 
            let appleXmlUrl = outputApple,
            let appleXmlDocument = try? XMLDocument(contentsOf: appleXmlUrl, options: [.nodePreserveAll]),
            let appleRootXMLElement: XMLElement = appleXmlDocument.rootElement() {
            // Generate and save expected keys
            _xmlKeysExpectedApple = Set<String>()
            generateExpectedAppleKeys(node: appleRootXMLElement)
            let keysExpectedString = _xmlKeysExpectedApple.joined(separator: "\n")
            do {
                let url = appleXmlUrl
                    .deletingLastPathComponent()
                    .appendingPathComponent("keysExpectedXliff_\(Date.datestampyyyyMMddHHmm).txt")
                try keysExpectedString.write(to: url, atomically: true, encoding: .utf8)
            } catch { print(error) }
            // Process XML File          
            _lookupTable = sheet.getLookupDictApple()
            _xmlKeysProcessed = Set<String>()
            processNodeAppleImport(node: appleRootXMLElement)
            // printNodeTree(node: appleRootXMLElement)
            
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
        
        // 3. Process Android XML File
        
        if 
            let droidXmlUrl = outputAndroid,
            let droidXmlDocument = try? XMLDocument(contentsOf: droidXmlUrl, options: [.nodePreserveAll, .nodePreserveWhitespace]),
            let droidRootXMLElement: XMLElement = droidXmlDocument.rootElement() {
            // Generate and save expected keys
            _xmlKeysExpectedDroid = Set<String>()
            generateExpectedDroidKeys(node: droidRootXMLElement)
            let keysExpectedString = _xmlKeysExpectedDroid.joined(separator: "\n")
            do {
                let url = droidXmlUrl
                    .deletingLastPathComponent()
                    .appendingPathComponent("keysExpectedXml_\(Date.datestampyyyyMMddHHmm).txt")
                try keysExpectedString.write(to: url, atomically: true, encoding: .utf8)
            } catch { print(error) }
            // Process XML File          
            _lookupTable = sheet.getLookupDictAndroid()
            _xmlKeysProcessed = Set<String>()
            processNodeDroidImport(node: droidRootXMLElement)
            //printNodeTree(node: droidRootXMLElement)
            
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
                
        reportImportCoverage(tsvUrl: inputTSV)
    }
    
    mutating func generateExpectedAppleKeys(node :XMLNode) {
        if let name = node.name, 
           name == "trans-unit", 
           let element = node as? XMLElement,
           let id = element.attribute(forName: "id")?.stringValue
        {
            _xmlKeysExpectedApple.insert(id)
        } else if let children = node.children {
            for node: XMLNode in children {
                generateExpectedAppleKeys(node: node)
            }
        }
    }
    
    mutating func generateExpectedDroidKeys(node :XMLNode) {
        if let name = node.name, 
           let children = node.children, // has children
           let element = node as? XMLElement,
           let keyId = element.attribute(forName: "name")?.stringValue {
            switch name {
            case "string":
                _xmlKeysExpectedDroid.insert(keyId)
            case "string-array":
                for i in 0 ..< children.count {
                    _xmlKeysExpectedDroid.insert("\(keyId).\(i)")
                }
            default:
                break
            }            
        } else if let children = node.children {
            for node: XMLNode in children {
                generateExpectedDroidKeys(node: node)
            }
        }
    }
    
    mutating func processNodeAppleImport(node :XMLNode) {
        //print(node.toStringNode())
        if let name = node.name, 
           name == "trans-unit", 
           let children = node.children,
           let element = node as? XMLElement,
           let id = element.attribute(forName: "id")?.stringValue
        {
            print("• \(id) ••", terminator: "")
            var sourceNode: XMLNode!
            var targetNode: XMLNode!
            var noteNode: XMLNode!
            for child in children {
                guard let childname = child.name else { continue }
                switch childname {
                case "source":
                    sourceNode = child
                case "target":
                    targetNode = child
                    if let value = _lookupTable[id] {
                        targetNode.stringValue = value
                        _xmlKeysProcessed.insert(id)
                    } else {
                        print(":WARNING: apple key not found lookup table '\(id)'")
                    }
                case "note":
                    noteNode = child
                default:
                    break
                }
            }
            print("\(sourceNode.stringValue!) •• \(targetNode.stringValue!) •• \(noteNode.stringValue ?? "nil")")
        } else if let children = node.children {
            for node: XMLNode in children {
                processNodeAppleImport(node: node)
            }
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
           let keyId = element.attribute(forName: "name")?.stringValue {
            switch name {
            case "string":
                print(keyId)
                if let value = _lookupTable[keyId] {
                    node.stringValue = value
                    _xmlKeysProcessed.insert(keyId)
                } else {
                    print(":WARNING: Android keyId not found _lookupTable '\(keyId)'")
                }
            case "string-array":
                print("\(keyId):\(children.count)")
            default:
                break
            }            
        } else if let children = node.children {
            for node: XMLNode in children {
                processNodeDroidImport(node: node)
            }
        }
    }
    
    func printNodeTree(node :XMLNode) {
        print(node.toStringNode())
        if let children = node.children {
            for node: XMLNode in children {
                printNodeTree(node: node)
            }
        }
    }
    
    func loadImportMapping() {
        
    }
    
    func loadExportMapping() {
        
    }
    
    func reportImportCoverage(tsvUrl: URL) {
        let datestamp = Date.datestampyyyyMMddHHmm
        var s = "Coverage Report \(datestamp)\n"
        let url = tsvUrl
            .deletingLastPathComponent()
            .appendingPathComponent("CoverageReport_\(datestamp).txt")
        
        s.append(_xmlKeysProcessed.joined(separator: "\n"))
        
        
        try? s.write(to: url, atomically: true, encoding: .utf8)
    }
    
}
