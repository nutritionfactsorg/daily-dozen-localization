//
//  BatchRunner.swift
//  AppLocalizerLib
//
//  Created by marc on 2020.08.25.
//

import Foundation

/// See: https://en.wikipedia.org/wiki/Quotation_mark#Summary_table

struct BatchRunner {
    // Batch Commands File URL
    let commandsUrl: URL
    let languagesUrl: URL
    let mappingsUrl: URL
    
    init(commandsUrl: URL, languagesUrl: URL, mappingsUrl: URL) {
        self.commandsUrl = commandsUrl
        self.languagesUrl = languagesUrl
        self.mappingsUrl = mappingsUrl
    }
    
    func run() {
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
    
    func doImport(
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
        
        // 2. Open XMLDocument Output Files
        if 
            let outputApple = outputApple,
            let appleXmlDocument = try? XMLDocument(contentsOf: outputApple, options: []),
            let appleRootXMLElement: XMLElement = appleXmlDocument.rootElement() {
            processNodeAppleImport(node: appleRootXMLElement)
            // printNodeTree(node: appleRootXMLElement)
        }
        
        if 
            let outputDroid = outputAndroid,
            let droidXmlDocument = try? XMLDocument(contentsOf: outputDroid, options: []),
            let droidRootXMLElement: XMLElement = droidXmlDocument.rootElement() {
            processNodeDroidImport(node: droidRootXMLElement)
            //printNodeTree(node: droidRootXMLElement)
        }
        
        // 3. Write translation string to output file
        
        for row: TsvImportRow in sheet.recordList {
            if row.key_apple.isEmpty == false {
                
            }
        }
        
    }
    
    func processNodeAppleImport(node :XMLNode) {
        //print(node.toStringNode())
        if let name = node.name, 
           name == "trans-unit", 
           let children = node.children,
           let element = node as? XMLElement,
           let id = element.attribute(forName: "id")?.stringValue
        {
            print(id)
            var sourceValue: XMLNode!
            var targetValue: XMLNode!
            var noteValue: XMLNode?
            for child in children {
                switch child.name! {
                case "source":
                    sourceValue = child.children!.first
                case "target":
                    targetValue = child.children!.first
                case "note":
                    if let first = child.children?.first {
                        noteValue = first
                    } 
                default:
                    break
                }
            }
            print("\(sourceValue.stringValue!) •• \(targetValue.stringValue!) •• \(noteValue?.stringValue ?? "nil")")
        } else if let children = node.children {
            for node: XMLNode in children {
                processNodeAppleImport(node: node)
            }
        }
    }
    
    func processNodeDroidImport(node :XMLNode) {
        //print(node.toStringNode())
        if let name = node.name, 
           name == "string", 
           let children = node.children,
           let element = node as? XMLElement,
           let keyId = element.attribute(forName: "name")?.stringValue {
            print(keyId)
        } else if let name = node.name, 
                  name == "string-array", 
                  let children = node.children,
                  let element = node as? XMLElement,
                  let keyId = element.attribute(forName: "name")?.stringValue {
            print("\(keyId):\(children.count)")
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
    
}
