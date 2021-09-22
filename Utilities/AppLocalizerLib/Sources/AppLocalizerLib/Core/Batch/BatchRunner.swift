//
//  BatchRunner.swift
//  AppLocalizerLib
//

import Foundation

struct BatchRunner {

    // Batch Commands File URL
    let commandsUrl: URL
    let languagesUrl: URL
    let mappingsUrl: URL // currently not used
    
    init(commandsUrl: URL, languagesUrl: URL, mappingsUrl: URL) {
        self.commandsUrl = commandsUrl
        self.languagesUrl = languagesUrl
        self.mappingsUrl = mappingsUrl
    }
    
    mutating func run() {
        // Batch Diff Parameters
        var diffTsvA: [URL]?
        var diffTsvB: [URL]?
        var diffXmlA: URL?
        var diffXmlB: URL?
        var diffXliffA: URL?
        var diffXliffB: URL?
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
        // Batch Normal Parameters
        var inputXLIFF: URL?
        
        guard let commands = try? String(contentsOf: commandsUrl) else {
            fatalError("could not read commands")
        }
        
        let lines = commands.components(separatedBy: CharacterSet.newlines)
        
        for l in lines {
            guard let cmd = parseCommandLine(l) else { continue }
            //print("cmd `\(cmd.key)` \(cmd.url?.absoluteString ?? "nil")")
            
            // Clear
            if cmd.key.hasPrefix("CLEAR_ALL") {
                BatchExport.shared.clearAll()
                BatchImport.shared.clearAll()
                diffTsvA = nil
                diffTsvB = nil
                diffXmlA = nil
                diffXmlB = nil
                diffXliffA = nil
                diffXliffB = nil
                outputLangTsv = nil
                sourceEnUSTsv = nil
                sourceEnUSDroid = nil
                sourceLangDroid = nil
                sourceEnUSApple = nil
                sourceLangApple = nil
                inputTSV = nil
                inputXLIFF = nil
                outputDroid = nil
                outputApple = nil
            } 
            // Diff
            else if cmd.key.hasPrefix("DIFF_TSV_A") {
                if let url = cmd.url {
                    if diffTsvA == nil {
                        diffTsvA = [url]
                    } else {
                        diffTsvA?.append(url)
                    } 
                }
            }             
            else if cmd.key.hasPrefix("DIFF_TSV_B") {
                if let url = cmd.url {
                    if diffTsvB == nil {
                        diffTsvB = [url]
                    } else {
                        diffTsvB?.append(url)
                    } 
                }
            }             
            else if cmd.key.hasPrefix("DIFF_XML_A") {
                diffXmlA = cmd.url
            }             
            else if cmd.key.hasPrefix("DIFF_XML_B") {
                diffXmlB = cmd.url
            }             
            else if cmd.key.hasPrefix("DIFF_XLIFF_A") {
                diffXliffA = cmd.url
            }             
            else if cmd.key.hasPrefix("DIFF_XLIFF_B") {
                diffXliffB = cmd.url
            }             
            else if cmd.key.hasPrefix("DO_DIFF_KEYS") {
                BatchDiff.shared.doDiffKeys(tsvUrlListA: diffTsvA, tsvUrlListB: diffTsvB, xmlUrlA: diffXmlA, xmlUrlB: diffXmlB, xliffUrlA: diffXliffA, xliffUrlB: diffXliffB)
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
                    BatchImport.shared.doImport(inputTSV: inputTSV, 
                             outputAndroid: outputDroid, 
                             outputApple: outputApple)
                } else {
                    print(":ERROR: BatchRunner run() missing SOURCE_TSV")
                }
            }
            // Normal
            else if cmd.key.hasPrefix("INPUT_XLIFF") {
                inputXLIFF = cmd.url
            }
            else if cmd.key.hasPrefix("DO_NORMALIZE") {
                if let inputXLIFF = inputXLIFF {
                    BatchNormal.shared.doNormalize(inputXLIFF: inputXLIFF)
                } else {
                    print(":ERROR: DO_NORMALIZE some required url missing.")
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
    
}
