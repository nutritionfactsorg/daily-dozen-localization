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
    private var _jsonProcessor: JsonProcessor!         // key_apple    
    private var _xliffProcessor: XliffProcessor!
    private var _xmlProcessor: XmlProcessor!
    
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
        let sheet = TsvImportSheet(urlList: inputTSV, loglevel: .info)
        
        // 2. Process Apple JSON Files
        if let appleXmlUrl = outputApple {
            _jsonProcessor = JsonProcessor(xliffUrl: appleXmlUrl)
            _jsonProcessor.process(lookupTable: sheet.getLookupDictApple())
            _jsonProcessor.writeJsonFiles()
        }
        
        // 3. Process Apple XLIFF XMLDocument
        if 
            let appleXmlUrl = outputApple,
            let appleXmlDocument = try? XMLDocument(contentsOf: appleXmlUrl, options: [.nodePreserveAll]),
            let appleRootXMLElement: XMLElement = appleXmlDocument.rootElement() {
            _xliffProcessor = XliffProcessor(lookupTable: sheet.getLookupDictApple())
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
            let droidXmlDocument = try? XMLDocument(contentsOf: droidXmlUrl, options: [.nodePreserveAll, .nodePreserveWhitespace]),
            let droidRootXMLElement: XMLElement = droidXmlDocument.rootElement() {
            _xmlProcessor = XmlProcessor(lookupTable: sheet.getLookupDictAndroid())
            _xmlProcessor.process(
                droidXmlUrl: droidXmlUrl, 
                droidXmlDocument: droidXmlDocument, 
                droidRootXMLElement: droidRootXMLElement
            )
            // file writing included in `process(…)`
        }
                
        // 5. Write Report
        writeReport(tsvSheet: sheet, tsvUrl: inputTSV[0])
    }
    
    func writeReport(tsvSheet: TsvImportSheet, tsvUrl: URL, verbose: Bool = false) {
        let datestamp = Date.datestampyyyyMMddHHmm
        let url = tsvUrl
            .deletingLastPathComponent()
            .appendingPathComponent("Report_\(datestamp).txt")
        
        var s = "Report: \(datestamp)\n"
        s.append("\n")
        s.append("###########################\n")
        s.append("## TSV STANDALONE CHECKS ##\n")
        s.append("###########################\n")
        s.append("\n")
        s.append("********************************\n")
        s.append("** TSV: Target Language Empty **\n")
        s.append("********************************\n")
        let missing = tsvSheet.checkTsvKeysTargetValueMissing()
        for r in missing {
            s.append("\(r.key_android)\t\(r.key_apple)\t\(r.base_value)\t\(r.lang_value)\n")
        }
            
        s.append("\n")
        s.append("*******************************************\n")
        s.append("** TSV: Target Language == Base Language **\n")
        s.append("*******************************************\n")
        let unchanged = tsvSheet.checkTsvKeysTargetValueSameAsBase()        
        for r in unchanged {
            s.append("\(r.key_android)\t\(r.key_apple)\t\(r.base_value)\t\(r.lang_value)\n")
        }

        if let processor = _xmlProcessor {
            s.append("\n")
            s.append("####################\n")
            s.append("## ANDROID CHECKS ##\n")
            s.append("####################\n")
            s.append("\n")
            s.append("*****************************************\n")
            s.append("** TSV: Unused key_android in TSV file **\n")
            s.append("*****************************************\n")
            let unusedDroid = tsvSheet.checkTsvKeysNotused(platformKeysUsed: processor.keysDroidXmlMatched, platform: .android)
            s.append(unusedDroid.sorted().joined(separator: "\n"))
            s.append("\n\n")
            s.append("********************************\n")
            s.append("** Android XML Keys UnMatched **\n")
            s.append("********************************\n")
            s.append(processor.keysDroidXmlUnmatched.sorted().joined(separator: "\n"))
            if verbose {
                s.append("\n\n")
                s.append("******************************\n")
                s.append("** Android XML Keys Matched **\n")
                s.append("******************************\n")
                s.append(processor.keysDroidXmlMatched.sorted().joined(separator: "\n"))
            }
        }
        
        if let processor = _xliffProcessor, let jprocessor = _jsonProcessor {
            s.append("\n\n")
            s.append("##################\n")
            s.append("## APPLE CHECKS ##\n")
            s.append("##################\n")
            s.append("\n")
            s.append("***************************\n")
            s.append("** TSV: Unused Apple Key **\n")
            s.append("***************************\n")
            let usedKeys = processor.keysAppleXliffMatched.union(jprocessor.keysAppleJsonMatched)
            let unusedApple = tsvSheet.checkTsvKeysNotused(platformKeysUsed: usedKeys, platform: .apple)
            s.append(unusedApple.sorted().joined(separator: "\n"))
            s.append("\n\n")
            s.append("*******************************\n")
            s.append("** Apple JSON Keys UnMatched **\n")
            s.append("*******************************\n")
            s.append(jprocessor.keysAppleJsonUnmatched.sorted().joined(separator: "\n"))
            s.append("\n\n")
            s.append("********************************\n")
            s.append("** Apple XLIFF Keys UnMatched **\n")
            s.append("********************************\n")
            s.append(processor.keysAppleXliffUnmatched.sorted().joined(separator: "\n"))
            if verbose {
                s.append("\n\n")
                s.append("*****************************\n")
                s.append("** Apple JSON Keys Matched **\n")
                s.append("*****************************\n")
                s.append(jprocessor.keysAppleJsonMatched.sorted().joined(separator: "\n"))
                s.append("\n\n")
                s.append("******************************\n")
                s.append("** Apple XLIFF Keys Matched **\n")
                s.append("******************************\n")
                s.append(processor.keysAppleXliffMatched.sorted().joined(separator: "\n"))
            }
        }
        
        try? s.write(to: url, atomically: true, encoding: .utf8)
    }
    
}
