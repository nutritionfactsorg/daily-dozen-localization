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
    // Data Processors 
    var _jsonProcessor: JsonProcessor!         // key_apple    
    var _tsvImportSheet: TsvSheet!
    var _xliffProcessor: XliffProcessor!
    var _xmlProcessor: XmlProcessor!
    
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
        var inputTSV: [URL]?
        var outputAndroid: URL?
        var outputApple: URL?
        
        guard let commands = try? String(contentsOf: commandsUrl) else {
            fatalError("could not read commands")
        }
        
        let lines = commands.components(separatedBy: CharacterSet.newlines)
        
        for l in lines {
            guard let cmd = parseCommandLine(l) else { continue }
            
            // Clear
            if cmd.key.hasPrefix("CLEAR_ALL") { // Clears Language Target URLs
                _jsonProcessor = nil
                _xliffProcessor = nil
                _xmlProcessor = nil
                inputBaseAndroid = nil
                inputBaseApple = nil
                inputTargetAndroid = nil
                inputTargetApple = nil
                outputTSV = nil
                inputTSV = nil
                outputAndroid = nil
                outputApple = nil
            } 
            
            // Export
            else if cmd.key.hasPrefix("INPUT_BASE_ANDROID") {
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
                if let url = cmd.url {
                    if inputTSV == nil {
                        inputTSV = [URL]()
                    }
                    inputTSV?.append(url)
                }
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
    
    private func parseCommandLine(_ line: String) -> (key: String, url: URL?)? {
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
        inputTSV: [URL], 
        outputAndroid: URL?, 
        outputApple: URL?
    ) {
        print("""
        ### DO_IMPORT_TSV doImport() ###
               inputTSV = \(inputTSV)
          outputAndroid = \(outputAndroid?.absoluteString ?? "nil")
            outputApple = \(outputApple?.absoluteString ?? "nil")
        """)
        
        // 1. TSV Input File
        _tsvImportSheet = TsvSheet(urlList: inputTSV, loglevel: .info)
        
        // 2. Process Apple JSON Files
        if let appleXmlUrl = outputApple {
            _jsonProcessor = JsonProcessor(xliffUrl: appleXmlUrl)
            _jsonProcessor.process(lookupTable: _tsvImportSheet.getLookupDictApple())
            _jsonProcessor.writeJsonFiles()
        }
        
        // 3. Process Apple XLIFF XMLDocument
        if 
            let appleXmlUrl = outputApple,
            let appleXmlDocument = try? XMLDocument(contentsOf: appleXmlUrl, options: [.nodePreserveAll]),
            let appleRootXMLElement: XMLElement = appleXmlDocument.rootElement() {
            _xliffProcessor = XliffProcessor(lookupTable: _tsvImportSheet.getLookupDictApple())
            _xliffProcessor.process(
                appleXmlUrl: appleXmlUrl, 
                appleXmlDocument: appleXmlDocument, 
                appleRootXMLElement: appleRootXMLElement
            )
            // file writing included in `process(…)`
        }
        
        // 4. Process Android XML File
        if 
            let droidXmlUrl = outputAndroid,
            let droidXmlDocument = try? XMLDocument(contentsOf: droidXmlUrl, options: [.nodePreserveAll, .nodePreserveWhitespace]) {
            droidXmlDocument.version = nil // remove <?xml version="1.0"?> from output
            _xmlProcessor = XmlProcessor(lookupTable: _tsvImportSheet.getLookupDictAndroid())
            _xmlProcessor.process(
                droidXmlUrl: droidXmlUrl, 
                droidXmlDocument: droidXmlDocument
            )
            // file writing included in `process(…)`
        }
                
        // 5. Write Report
        Reporter.shared.writeFullReport(batchRunner: self)
        Reporter.shared.writeFullReport(batchRunner: self, verbose: true)
    }

}
