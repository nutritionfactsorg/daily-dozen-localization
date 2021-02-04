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
    var _jsonProcessor: JsonFromTsvProcessor!         // key_apple    
    var _tsvImportSheet: TsvSheet!
    var _xliffProcessor: XliffFromTsvProcessor!
    var _xmlProcessor: XmlFromTsvProcessor!
    
    init(commandsUrl: URL, languagesUrl: URL, mappingsUrl: URL) {
        self.commandsUrl = commandsUrl
        self.languagesUrl = languagesUrl
        self.mappingsUrl = mappingsUrl
    }
    
    mutating func run() {
        // Batch Export Parameters
        var outputLangTsv: URL?
        var sourceEnUSTsv: URL?
        var sourceEnUSDroid: URL?
        var sourceLangDroid: URL?
        var sourceEnUSApple: URL?
        var sourceLangApple: URL?
        // Batch Import Parameters
        var inputTSV: [URL]?
        var outputDroid: URL?
        var outputApple: URL?
        
        guard let commands = try? String(contentsOf: commandsUrl) else {
            fatalError("could not read commands")
        }
        
        let lines = commands.components(separatedBy: CharacterSet.newlines)
        
        for l in lines {
            guard let cmd = parseCommandLine(l) else { continue }
            //print("cmd `\(cmd.key)` \(cmd.url?.absoluteString ?? "nil")")
            
            // Clear
            if cmd.key.hasPrefix("CLEAR_ALL") {
                _jsonProcessor = nil
                _xliffProcessor = nil
                _xmlProcessor = nil
                outputLangTsv = nil
                sourceEnUSTsv = nil
                sourceEnUSDroid = nil
                sourceLangDroid = nil
                sourceEnUSApple = nil
                sourceLangApple = nil
                inputTSV = nil
                outputDroid = nil
                outputApple = nil
            } 
            
            // Export
            else if cmd.key.hasPrefix("OUTPUT_LANG_TSV") {
                outputLangTsv = cmd.url
            } 
            else if cmd.key.hasPrefix("SOURCE_ENUS_TSV") {
                sourceEnUSTsv = cmd.url
            } 
            else if cmd.key.hasPrefix("SOURCE_ENUS_DROID") {
                sourceEnUSDroid = cmd.url
            }
            else if cmd.key.hasPrefix("SOURCE_LANG_DROID") {
                sourceLangDroid = cmd.url
            } 
            else if cmd.key.hasPrefix("SOURCE_ENUS_APPLE") {
                sourceEnUSApple = cmd.url
            } 
            else if cmd.key.hasPrefix("SOURCE_LANG_APPLE") {
                sourceLangApple = cmd.url
            } 
            else if cmd.key.hasPrefix("DO_EXPORT_TSV") {
                if 
                    let outputLangTsv = outputLangTsv,
                    let sourceEnUSTsv = sourceEnUSTsv,
                    let sourceEnUSDroid = sourceEnUSDroid,
                    let sourceLangDroid = sourceLangDroid,
                    let sourceEnUSApple = sourceEnUSApple,
                    let sourceLangApple = sourceLangApple
                   {
                    BatchExport.shared.doExport(
                        outputLangTsv: outputLangTsv,
                        sourceEnUSTsv: sourceEnUSTsv,
                        sourceEnUSDroid: sourceEnUSDroid, 
                        sourceLangDroid: sourceLangDroid, 
                        sourceEnUSApple: sourceEnUSApple, 
                        sourceLangApple: sourceLangApple
                        )
                } else {
                    print(":ERROR: DO_EXPORT_TSV some required url missing.")
                }
            } 
            // Import
            else if cmd.key.hasPrefix("SOURCE_TSV") {
                if let url = cmd.url {
                    if inputTSV == nil {
                        inputTSV = [URL]()
                    }
                    inputTSV?.append(url)
                }
            } 
            else if cmd.key.hasPrefix("OUTPUT_DROID") {
                outputDroid = cmd.url
            } 
            else if cmd.key.hasPrefix("OUTPUT_APPLE") {
                outputApple = cmd.url
            } 
            else if cmd.key.hasPrefix("DO_IMPORT_TSV") {
                if let inputTSV = inputTSV {
                    doImport(inputTSV: inputTSV, 
                             outputAndroid: outputDroid, 
                             outputApple: outputApple)
                } else {
                    print(":ERROR: BatchRunner run() missing SOURCE_TSV")
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
            _jsonProcessor = JsonFromTsvProcessor(xliffUrl: appleXmlUrl)
            _jsonProcessor.processTsvToJson(lookupTable: _tsvImportSheet.getLookupDictApple())
            _jsonProcessor.writeJsonFiles()
        }
        
        // 3. Process Apple XLIFF XMLDocument
        if 
            let appleXmlUrl = outputApple,
            let appleXmlDocument = try? XMLDocument(contentsOf: appleXmlUrl, options: [.nodePreserveAll]),
            let appleRootXMLElement: XMLElement = appleXmlDocument.rootElement() {
            _xliffProcessor = XliffFromTsvProcessor(lookupTable: _tsvImportSheet.getLookupDictApple())
            _xliffProcessor.processXliffFromTsv(
                appleXmlUrl: appleXmlUrl, 
                appleXmlDocument: appleXmlDocument, 
                appleRootXMLElement: appleRootXMLElement
            )
            // file writing included in `processXliffFromTsv(…)`
        }
        
        // 4. Process Android XML File
        if 
            let droidXmlUrl = outputAndroid,
            let droidXmlDocument = try? XMLDocument(contentsOf: droidXmlUrl, options: [.nodePreserveAll, .nodePreserveWhitespace]) {
            droidXmlDocument.version = nil // remove <?xml version="1.0"?> from output
            _xmlProcessor = XmlFromTsvProcessor(lookupTable: _tsvImportSheet.getLookupDictAndroid())
            _xmlProcessor.processXmlFromTsv(
                droidXmlUrl: droidXmlUrl, 
                droidXmlDocument: droidXmlDocument
            )
            // file writing included in `processXmlFromTsv(…)`
        }
                
        // 5. Write Report
        Reporter.shared.writeFullReport(batchRunner: self)
        Reporter.shared.writeFullReport(batchRunner: self, verbose: true)
    }

}
