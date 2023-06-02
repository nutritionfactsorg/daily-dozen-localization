//
//  BatchRunner.swift
//  AppLocalizerLib
//

import Foundation

struct BatchRunner {

    // Batch Commands File URL
    let commandsUrl: URL   // …/SCRIPT_BEING_EXECUTED.txt
    let languagesUrl: URL  // …/Languages
    let mappingsUrl: URL   // currently not used
    let logger = LogService.shared
    
    var outputNormalDir: URL? // Batch: normal

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
        var baseJsonDir: URL?
        var baseXmlUrl: URL?
        var sourceListTSV: [URL]?  // Batch: import, normal
        var outputDroid: URL?
        var outputApple: URL?
        // Batch Normal Parameters
        var sourceStrings: [URL]? // Batch: normal
        var sourceXLIFF: URL?     // Batch: normal
        var sourceXML: URL?       // Batch: normal
        var baseListTsv: [URL]?   // Batch: normal
        var urlFragmentsTsv: URL? // Batch: normal
        var urlTopicsTsv: URL?    // Batch: normal
        
        guard let commands = try? String(contentsOf: commandsUrl) else {
            fatalError("could not read commands")
        }
        
        let lines = commands.components(separatedBy: CharacterSet.newlines)
        
        for l in lines {
            guard let command = parseCommandLine(l) else { continue }
            //print("cmd `\(command.cmdKey)` \(cmd.cmdUrl?.absoluteString ?? "nil")")
            
            // Clear
            if command.cmdKey.hasPrefix("CLEAR_ALL") {
                BatchExport.shared.clearAll()
                BatchImport.shared.clearAll()
                baseJsonDir = nil
                baseListTsv = nil
                baseXmlUrl = nil
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
                sourceStrings = nil
                sourceListTSV = nil
                sourceXLIFF = nil
                sourceXML = nil
                outputDroid = nil
                outputApple = nil
                outputNormalDir = nil
                urlFragmentsTsv = nil
                urlTopicsTsv = nil
            } 
            // Diff
            else if command.cmdKey.hasPrefix("DIFF_TSV_A") {
                if let url = command.cmdUrl {
                    if diffTsvA == nil {
                        diffTsvA = [url]
                    } else {
                        diffTsvA?.append(url)
                    } 
                }
            }             
            else if command.cmdKey.hasPrefix("DIFF_TSV_B") {
                if let url = command.cmdUrl {
                    if diffTsvB == nil {
                        diffTsvB = [url]
                    } else {
                        diffTsvB?.append(url)
                    } 
                }
            }             
            else if command.cmdKey.hasPrefix("DIFF_XML_A") {
                diffXmlA = command.cmdUrl
            }             
            else if command.cmdKey.hasPrefix("DIFF_XML_B") {
                diffXmlB = command.cmdUrl
            }             
            else if command.cmdKey.hasPrefix("DIFF_XLIFF_A") {
                diffXliffA = command.cmdUrl
            }             
            else if command.cmdKey.hasPrefix("DIFF_XLIFF_B") {
                diffXliffB = command.cmdUrl
            }             
            else if command.cmdKey.hasPrefix("DO_DIFF_KEYS") {
                BatchDiff.shared.doDiffKeys(tsvUrlListA: diffTsvA, tsvUrlListB: diffTsvB, xmlUrlA: diffXmlA, xmlUrlB: diffXmlB, xliffUrlA: diffXliffA, xliffUrlB: diffXliffB)
            }             
            // Export
            else if command.cmdKey.hasPrefix("OUTPUT_LANG_TSV") {
                outputLangTsv = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix("SOURCE_ENUS_TSV") {
                sourceEnUSTsv = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix("SOURCE_ENUS_DROID") {
                sourceEnUSDroid = command.cmdUrl
            }
            else if command.cmdKey.hasPrefix("SOURCE_LANG_DROID") {
                sourceLangDroid = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix("SOURCE_ENUS_APPLE") {
                sourceEnUSApple = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix("SOURCE_LANG_APPLE") {
                sourceLangApple = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix("DO_EXPORT_TSV") {
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
            else if command.cmdKey.hasPrefix("SOURCE_STRINGS") {
                if let url = command.cmdUrl {
                    if sourceStrings == nil {
                        sourceStrings = [URL]()
                    }
                    sourceStrings?.append(url)
                }
            }
            else if command.cmdKey.hasPrefix("SOURCE_TSV_INCLUDE") {
                if let url = command.cmdUrl {
                    if sourceListTSV == nil {
                        sourceListTSV = [URL]()
                    }
                    sourceListTSV?.append(url)
                }
            } 
            else if command.cmdKey.hasPrefix("BASE_JSON_DIR") {
                if let url = command.cmdUrl {
                    baseJsonDir = url
                }
            }
            else if command.cmdKey.hasPrefix("BASE_TSV_INCLUDE") {
                if let url = command.cmdUrl {
                    if baseListTsv == nil {
                        baseListTsv = [URL]()
                    }
                    baseListTsv?.append(url)
                }
            }
            else if command.cmdKey.hasPrefix("BASE_XML_URL") {
                if let url = command.cmdUrl {
                    baseXmlUrl = url
                }
            }
            else if command.cmdKey.hasPrefix("URL_FRAGMENTS_TSV") {
                if let url = command.cmdUrl {
                    urlFragmentsTsv = url
                }
            }
            else if command.cmdKey.hasPrefix("URL_TOPICS_TSV") {
                if let url = command.cmdUrl {
                    urlTopicsTsv = url
                }
            } 
            else if command.cmdKey.hasPrefix("SOURCE_XLIFF") {
                sourceXLIFF = command.cmdUrl
            }
            else if command.cmdKey.hasPrefix("SOURCE_XML") {
                sourceXML = command.cmdUrl
            }
            else if command.cmdKey.hasPrefix("OUTPUT_APPLE") {
                outputApple = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix("OUTPUT_DROID") {
                outputDroid = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix("DIRNAME_OUTPUT_NORMAL") {
                // dirname used inside "…/_Normal__LOCAL/"  
                outputNormalDir = command.cmdUrl
            }
            else if command.cmdKey.hasPrefix("DO_IMPORT_TSV") {
                if let sourceTSV = sourceListTSV {
                    BatchImport.shared.doImport(sourceTSV: sourceTSV, 
                             outputAndroid: outputDroid, 
                             outputApple: outputApple)
                } else {
                    print(":ERROR: BatchRunner run() missing SOURCE_TSV_INCLUDE")
                }
            }
            else if command.cmdKey.hasPrefix("DO_INSET_BATCH") {
                // Additive: inserts secondary *.tsv into primary *.tsv.
                //     will reindex any key which ends with a dot-number
                logger.info("\n##### ----- DO_INSET_BATCH ----- ######")
                guard 
                    let outputNormalDir = outputNormalDir,
                    let source = sourceListTSV,
                    source.count > 1
                else {
                    let s = """
                    :ERROR: DO_INSET_BATCH
                        - verify DIRNAME_OUTPUT_NORMAL
                        - verify SOURCE_TSV_INCLUDE has two files
                    """
                    print(s)
                    continue
                }
                BatchNormal.shared.doInsetTsv(sourceTSV: source, resultsDir: outputNormalDir)
                sourceListTSV = nil
            }
            else if command.cmdKey.hasPrefix("DO_NORMALIZE_BATCH") {
                // Normalizes base on the given *.string, *.tsv, *.xliff, *.xml source
                logger.info("\n##### ----- DO_NORMALIZE_BATCH ----- ######")
                guard 
                    let outputNormalDir = outputNormalDir,
                    (sourceStrings != nil || sourceListTSV != nil || sourceXLIFF != nil || sourceXML != nil)
                else {
                    var s = ":ERROR: DO_NORMALIZE_BATCH missing required url(s)"
                    if outputNormalDir == nil {
                        s += "  missing DIRNAME_OUTPUT_NORMAL"
                    }
                    if sourceStrings == nil && sourceListTSV == nil && sourceXML == nil {
                        s += " missing SOURCE_TSV_INCLUDE (*.Strings, *.TSV or *.XML)"
                    }
                    print(s)
                    continue
                }
                // GIVEN: `.strings` source list
                if let source = sourceStrings {
                    BatchNormal.shared.doNormalize(sourceStrings: source, resultsDir: outputNormalDir)
                    sourceStrings = nil
                }
                // GIVEN: `.tsv` source list
                if let source = sourceListTSV, let baseJsonDir = baseJsonDir, let baseListTsv = baseListTsv, let baseXmlUrl = baseXmlUrl, let fragments = urlFragmentsTsv, let topics = urlTopicsTsv {
                    BatchNormal.shared.doNormalize(sourceTSV: source, resultsDir: outputNormalDir, baseJsonDir: baseJsonDir, baseListTsv: baseListTsv, baseTsvUrlFragments: fragments, baseTsvUrlTopics: topics, baseXmlUrl: baseXmlUrl)
                    sourceListTSV = nil
                }
                // GIVEN: `.xliff` source list
                if let source = sourceXLIFF {
                    BatchNormal.shared.doNormalize(sourceXLIFF: source, resultsDir: outputNormalDir)
                    sourceXLIFF = nil
                }
                // GIVEN: `.xml` source list
                if let sourceXml = sourceXML,
                    let baseListTsv = baseListTsv,
                    //let fragments = urlFragmentsTsv,
                    //let topics = urlTopicsTsv
                    let baseXmlUrl = baseXmlUrl
                {
                    BatchNormal.shared.doNormalize(
                        sourceXml: sourceXml,
                        resultsDir: outputNormalDir,
                        baseListTsv: baseListTsv,
                        //baseTsvUrlFragments: fragments,
                        //baseTsvUrlTopics: topics,
                        baseXmlUrl: baseXmlUrl)
                    sourceXML = nil
                } 
            }
            // ----- LogService -----
            else if command.cmdKey.hasPrefix("LOGGER_FILENAME") {
                // logfile placed inside "…/_Normal__LOCAL/"
                logger.useLogfile(url: command.cmdUrl)
            }
            else if command.cmdKey.hasPrefix("LOGGER_LEVEL_") {
                if command.cmdKey.hasPrefix("LOGGER_LEVEL_ALL") {
                    logger.logLevel = .all
                } else if command.cmdKey.hasPrefix("LOGGER_LEVEL_VERBOSE") {
                    logger.logLevel = .verbose
                } else if command.cmdKey.hasPrefix("LOGGER_LEVEL_DEBUG") {
                    logger.logLevel = .debug
                } else if command.cmdKey.hasPrefix("LOGGER_LEVEL_INFO") {
                    logger.logLevel = .info
                } else if command.cmdKey.hasPrefix("LOGGER_LEVEL_WARNING") {
                    logger.logLevel = .warning
                } else if command.cmdKey.hasPrefix("LOGGER_LEVEL_ERROR") {
                    logger.logLevel = .error
                } else if command.cmdKey.hasPrefix("LOGGER_LEVEL_OFF") {
                    logger.logLevel = .off
                }
            }
            // ----- Quit -----
            else if command.cmdKey.hasPrefix("QUIT") {
                return // exit loop and run()
            }
        }
    }
    
    private func parseCommandLine(_ line: String) -> (cmdKey: String, cmdUrl: URL?)? {
        let line = line.trimmingCharacters(in: CharacterSet.whitespaces)
        if line.isEmpty { return nil }
        if line.prefix(1) == "#" { return nil }
        
        let parts = line.components(separatedBy: "=")
        let cmdKey = parts[0]
            .trimmingCharacters(in: CharacterSet.whitespaces)
            .uppercased()
        var cmdValue = ""
        
        if parts.count == 1 {
            return (cmdKey: cmdKey, cmdUrl: nil)
        } 
        else if parts.count == 2 {
            cmdValue = parts[1].trimmingCharacters(in: CharacterSet.whitespaces)
            if (cmdValue.first != "\"") || (cmdValue.last != "\"") {
                print("\nERROR:A: Expected command value to be within double quotes. Did not process: '\(line)'")
                return nil
            }
            cmdValue = String(parts[1].dropFirst().dropLast())
            if cmdValue.isEmpty {
                return (cmdKey: cmdKey, cmdUrl: nil)
            } else if cmdKey == "LOGGER_FILENAME" {
                if let outputNormalDir = outputNormalDir {
                    let cmdUrl = outputNormalDir
                        .appendingPathComponent("_logs_")
                        .appendingPathComponent(cmdValue, isDirectory: false)
                    return (cmdKey: cmdKey, cmdUrl: cmdUrl)
                } else {
                    let cmdUrl = languagesUrl
                        .deletingLastPathComponent() // Languages
                        .appendingPathComponent("_Normal__LOCAL")
                        .appendingPathComponent(cmdValue, isDirectory: false)
                    return (cmdKey: cmdKey, cmdUrl: cmdUrl)
                }
            } else if cmdKey == "DIRNAME_OUTPUT_NORMAL" {
                let dirname = "\(cmdValue)_\(Date.datestampyyyyMMddHHmm)"
                let cmdUrl = languagesUrl
                    .deletingLastPathComponent() // Languages
                    .appendingPathComponent("_Normal__LOCAL")
                    .appendingPathComponent(dirname, isDirectory: true)
                return (cmdKey: cmdKey, cmdUrl: cmdUrl)
            } else if cmdKey == "SOURCE_STRINGS" {
                // Prerequisite: Development git repositories at same directory level.
                //               This level is used for relative path resolution.
                //               The path segment delimiter is `/`
                
                // relative to …/Languages
                var cmdUrl = languagesUrl
                    .deletingLastPathComponent() // Languages (in daily-dozen-localization)
                    .deletingLastPathComponent() // daily-dozen-localization
                let pathSegments = cmdValue.components(separatedBy: "/")
                var i = 0
                while i < (pathSegments.count - 1) {
                    cmdUrl.appendPathComponent(pathSegments[i])
                    i += 1
                }
                cmdUrl.appendPathComponent(pathSegments[i], isDirectory: false)
                return (cmdKey: cmdKey, cmdUrl: cmdUrl) 
            } else {
                let cmdUrl = languagesUrl.appendingPathComponent(cmdValue)
                return (cmdKey: cmdKey, cmdUrl: cmdUrl)
            }
        }
        else { // parts.count > 2
            print("ERROR:B: Too many line `parts`. Did not process: '\(line)'")
            return nil
        }
    }
    
}
