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
    
    var outputCacheLocalDir: URL? // Batch: `Languages/../_CACHE__LOCAL/`

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
        var sourceListTsv: [URL]?  // Batch: import, normal
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
            print("cmd `\(command.cmdKey)` \(command.cmdUrl?.lastPathComponent ?? "")")
            
            // Clear
            if command.cmdKey.hasPrefix(Cmd.CLEAR_ALL.txt) {
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
                sourceListTsv = nil
                sourceXLIFF = nil
                sourceXML = nil
                outputDroid = nil
                outputApple = nil
                outputCacheLocalDir = nil
                urlFragmentsTsv = nil
                urlTopicsTsv = nil
            } 
            // Diff
            else if command.cmdKey.hasPrefix(Cmd.DIFF_TSV_A.txt) {
                if let url = command.cmdUrl {
                    if diffTsvA == nil {
                        diffTsvA = [url]
                    } else {
                        diffTsvA?.append(url)
                    } 
                }
            }             
            else if command.cmdKey.hasPrefix(Cmd.DIFF_TSV_B.txt) {
                if let url = command.cmdUrl {
                    if diffTsvB == nil {
                        diffTsvB = [url]
                    } else {
                        diffTsvB?.append(url)
                    } 
                }
            }             
            else if command.cmdKey.hasPrefix(Cmd.DIFF_XML_A.txt) {
                diffXmlA = command.cmdUrl
            }             
            else if command.cmdKey.hasPrefix(Cmd.DIFF_XML_B.txt) {
                diffXmlB = command.cmdUrl
            }             
            else if command.cmdKey.hasPrefix(Cmd.DIFF_XLIFF_A.txt) {
                diffXliffA = command.cmdUrl
            }             
            else if command.cmdKey.hasPrefix(Cmd.DIFF_XLIFF_B.txt) {
                diffXliffB = command.cmdUrl
            }             
            else if command.cmdKey.hasPrefix(Cmd.DO_DIFF_KEYS.txt) {
                BatchDiff.shared.doDiffKeys(tsvUrlListA: diffTsvA, tsvUrlListB: diffTsvB, xmlUrlA: diffXmlA, xmlUrlB: diffXmlB, xliffUrlA: diffXliffA, xliffUrlB: diffXliffB)
            }             
            // Export
            else if command.cmdKey.hasPrefix(Cmd.OUTPUT_LANG_TSV.txt) {
                outputLangTsv = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix(Cmd.SOURCE_ENUS_TSV.txt) {
                sourceEnUSTsv = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix(Cmd.SOURCE_ENUS_DROID.txt) {
                sourceEnUSDroid = command.cmdUrl
            }
            else if command.cmdKey.hasPrefix(Cmd.SOURCE_LANG_DROID.txt) {
                sourceLangDroid = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix(Cmd.SOURCE_ENUS_APPLE.txt) {
                sourceEnUSApple = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix(Cmd.SOURCE_LANG_APPLE.txt) {
                sourceLangApple = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix(Cmd.DO_EXPORT_TSV.txt) {
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
            else if command.cmdKey.hasPrefix(Cmd.SOURCE_STRINGS.txt) {
                if let url = command.cmdUrl {
                    if sourceStrings == nil {
                        sourceStrings = [URL]()
                    }
                    sourceStrings?.append(url)
                }
            }
            else if command.cmdKey.hasPrefix(Cmd.SOURCE_TSV_INCLUDE.txt) {
                if let url = command.cmdUrl {
                    if sourceListTsv == nil {
                        sourceListTsv = [URL]()
                    }
                    sourceListTsv?.append(url)
                }
            } 
            else if command.cmdKey.hasPrefix(Cmd.BASE_JSON_DIR.txt) {
                if let url = command.cmdUrl {
                    baseJsonDir = url
                }
            }
            else if command.cmdKey.hasPrefix(Cmd.BASE_TSV_INCLUDE.txt) {
                if let url = command.cmdUrl {
                    if baseListTsv == nil {
                        baseListTsv = [URL]()
                    }
                    baseListTsv?.append(url)
                }
            }
            else if command.cmdKey.hasPrefix(Cmd.BASE_XML_URL.txt) {
                if let url = command.cmdUrl {
                    baseXmlUrl = url
                }
            }
            else if command.cmdKey.hasPrefix(Cmd.URL_FRAGMENTS_TSV.txt) {
                if let url = command.cmdUrl {
                    urlFragmentsTsv = url
                }
            }
            else if command.cmdKey.hasPrefix(Cmd.URL_TOPICS_TSV.txt) {
                if let url = command.cmdUrl {
                    urlTopicsTsv = url
                }
            } 
            else if command.cmdKey.hasPrefix(Cmd.SOURCE_XLIFF.txt) {
                sourceXLIFF = command.cmdUrl
            }
            else if command.cmdKey.hasPrefix(Cmd.SOURCE_XML.txt) {
                sourceXML = command.cmdUrl
            }
            else if command.cmdKey.hasPrefix(Cmd.OUTPUT_APPLE.txt) {
                outputApple = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix(Cmd.OUTPUT_DROID.txt) {
                outputDroid = command.cmdUrl
            } 
            else if command.cmdKey.hasPrefix(Cmd.OUTPUT_CACHE_LOCAL_DIR.txt) {
                // dirname used inside `…/_CACHE__LOCAL/`  
                outputCacheLocalDir = command.cmdUrl
                BatchChangeset.shared.outputCacheLocalDir = outputCacheLocalDir
            }
            else if command.cmdKey.hasPrefix(Cmd.DO_IMPORT_TSV.txt) {
                if let sourceTSV = sourceListTsv {
                    BatchImport.shared.doImport(sourceTSV: sourceTSV, 
                             outputAndroid: outputDroid, 
                             outputApple: outputApple)
                } else {
                    print(":ERROR: BatchRunner run() missing SOURCE_TSV_INCLUDE")
                }
            }
            else if command.cmdKey.hasPrefix(Cmd.DO_INSET_BATCH.txt) {
                // Additive: inserts secondary *.tsv into primary *.tsv.
                //     will reindex any key which ends with a dot-number
                logger.info("\n##### ----- DO_INSET_BATCH ----- ######")
                guard 
                    let outputNormalDir = outputCacheLocalDir,
                    let source = sourceListTsv,
                    source.count > 1
                else {
                    let s = """
                    :ERROR: DO_INSET_BATCH
                        - verify OUTPUT_CACHE_LOCAL_DIR
                        - verify SOURCE_TSV_INCLUDE has two files
                    """
                    print(s)
                    continue
                }
                BatchNormal.shared.doInsetTsv(sourceTSV: source, resultsDir: outputNormalDir)
                sourceListTsv = nil
            }
            else if command.cmdKey.hasPrefix(Cmd.DO_NORMALIZE_BATCH.txt) {
                // Normalizes base on the given *.string, *.tsv, *.xliff, *.xml source
                logger.info("\n##### ----- DO_NORMALIZE_BATCH ----- ######")
                guard 
                    let outputNormalDir = outputCacheLocalDir,
                    (sourceStrings != nil || sourceListTsv != nil || sourceXLIFF != nil || sourceXML != nil)
                else {
                    var s = ":ERROR: DO_NORMALIZE_BATCH missing required url(s)"
                    if outputCacheLocalDir == nil {
                        s += "  missing OUTPUT_CACHE_LOCAL_DIR"
                    }
                    if sourceStrings == nil && sourceListTsv == nil && sourceXML == nil {
                        s += " missing `SOURCE_TSV_INCLUDE` (*.Strings, *.TSV or *.XML)"
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
                if let source = sourceListTsv, let baseJsonDir = baseJsonDir, let baseListTsv = baseListTsv, let baseXmlUrl = baseXmlUrl, let fragments = urlFragmentsTsv, let topics = urlTopicsTsv {
                    BatchNormal.shared.doNormalize(sourceTSV: source, resultsDir: outputNormalDir, baseJsonDir: baseJsonDir, baseListTsv: baseListTsv, baseTsvUrlFragments: fragments, baseTsvUrlTopics: topics, baseXmlUrl: baseXmlUrl)
                    sourceListTsv = nil
                }
                // GIVEN: `.xliff` source list :OBSOLETE:
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
            
            // ------- Changeset -------
            else if command.cmdKey.hasPrefix(Cmd.CS_BASE_TSV.txt) {
                logger.info("\n##### ----- CS_BASE_TSV ----- ######")
                guard let csBaseTsvUrl = command.cmdUrl else { 
                    print("::: ERROR ::: CS_BASE_TSV missing url value")
                    continue
                }
                BatchChangeset.shared.addBaseTsvSheet(TsvSheet(csBaseTsvUrl))
            }
            else if command.cmdKey.hasPrefix(Cmd.CS_DELETE_KEY.txt) {
                logger.info("\n##### ----- CS_DELETE_KEY ----- ######")
                guard let deleteKey = command.cmdValue else { 
                    print("::: ERROR ::: CS_DELETE_KEY missing key value")
                    continue
                }
                BatchChangeset.shared.deleteSet.insert(deleteKey)
            }
            else if command.cmdKey.hasPrefix(Cmd.CS_INSERT_KEY.txt) {
                logger.info("\n##### ----- CS_INSERT_KEY ----- ######")
                guard let primaryKey = command.cmdValue else { 
                    print("::: ERROR ::: CS_INSERT_KEY missing key value")
                    continue
                }
                let tsvRow = TsvRow(primaryKey: primaryKey)
                BatchChangeset.shared.insertList.append(tsvRow)
            }
            else if command.cmdKey.hasPrefix(Cmd.CS_LANG_INPUT_TSV.txt) {
                logger.info("\n##### ----- CS_LANG_INPUT_TSV ----- ######\n\(command)")
                BatchChangeset.shared.langInputTsvUrl = command.cmdUrl
            }
            else if command.cmdKey.hasPrefix(Cmd.CS_LANG_OUTPUT_TSV.txt) {
                logger.info("\n##### ----- CS_LANG_OUTPUT_TSV ----- ######\n\(command)")
                BatchChangeset.shared.langOutputTsvUrl = command.cmdUrl
            }
            else if command.cmdKey.hasPrefix(Cmd.DO_CHANGESET_APPLY_TSV.txt) {
                // Generates changeset deltas to review
                logger.info("\n##### ----- DO_CHANGESET_APPLY_TSV ----- ######\n\(command)")
                BatchChangeset.shared.doChangesetApply()
            }
            else if command.cmdKey.hasPrefix(Cmd.DO_CHANGESET_WRITE_MULTI_TSV.txt) {
                // Generates multiple changeset deltas into a single file to review
                logger.info("\n##### ----- DO_CHANGESET_WRITE_MULTI_TSV ----- ######")
                guard let toUrl = command.cmdUrl else { 
                    print("::: ERROR ::: DO_CHANGESET_WRITE_MULTI_TSV missing path")
                    continue
                }
                BatchChangeset.shared.doChangesetWriteMulti(toUrl: toUrl)
            }
            else if command.cmdKey.hasPrefix(Cmd.DO_CHANGESET_INTAKE_MULTI.txt) {
                // Separates changset multi-delta intake into separate files 
                logger.info("\n##### ----- DO_CHANGESET_INTAKE_MULTI ----- ######")
                BatchChangeset.shared.doChangesetIntakeMulti()
                fatalError("DO_CHANGESET_INTAKE_MULTI not yet implemented.")
            }
            
            // ------- LogService -------
            else if command.cmdKey.hasPrefix(Cmd.LOGGER_FILENAME.txt) {
                // logfile placed inside `…/_CACHE__LOCAL/`
                logger.useLogfile(url: command.cmdUrl)
            }
            else if command.cmdKey.hasPrefix(Cmd.LOGGER_LEVEL_.txt) {
                if command.cmdKey.hasPrefix(Cmd.LOGGER_LEVEL_ALL.txt) {
                    logger.logLevel = .all
                } else if command.cmdKey.hasPrefix(Cmd.LOGGER_LEVEL_VERBOSE.txt) {
                    logger.logLevel = .verbose
                } else if command.cmdKey.hasPrefix(Cmd.LOGGER_LEVEL_DEBUG.txt) {
                    logger.logLevel = .debug
                } else if command.cmdKey.hasPrefix(Cmd.LOGGER_LEVEL_INFO.txt) {
                    logger.logLevel = .info
                } else if command.cmdKey.hasPrefix(Cmd.LOGGER_LEVEL_WARNING.txt) {
                    logger.logLevel = .warning
                } else if command.cmdKey.hasPrefix(Cmd.LOGGER_LEVEL_ERROR.txt) {
                    logger.logLevel = .error
                } else if command.cmdKey.hasPrefix(Cmd.LOGGER_LEVEL_OFF.txt) {
                    logger.logLevel = .off
                }
            }
            // ----- Quit -----
            else if command.cmdKey.hasPrefix(Cmd.QUIT.txt) {
                return // exit loop and run()
            }
        }
    }
    
    private func parseCommandLine(_ line: String) -> (cmdKey: String, cmdUrl: URL?, cmdValue: String?)? {
        let line = line.trimmingCharacters(in: CharacterSet.whitespaces)
        if line.isEmpty { return nil }
        if line.prefix(1) == "#" { return nil }
        
        let parts: [String] = line.split(separator: #/:\s+/#).map(String.init)
        let cmdKey = parts[0]
            .trimmingCharacters(in: CharacterSet.whitespaces)
            .uppercased()
        var cmdValue = ""
        
        if parts.count == 1 {
            return (cmdKey: cmdKey, cmdUrl: nil, cmdValue: nil)
        } 
        else if parts.count == 2 {
            cmdValue = parts[1].trimmingCharacters(in: CharacterSet.whitespaces)
            if (cmdValue.first != "\"") || (cmdValue.last != "\"") {
                print("\nERROR:A: Expected command value to be within double quotes. Did not process: '\(line)'")
                return nil
            }
            cmdValue = String(parts[1].dropFirst().dropLast())
            if cmdValue.isEmpty {
                return (cmdKey: cmdKey, cmdUrl: nil, cmdValue: nil)
            } else if cmdKey == "LOGGER_FILENAME" {
                if let outputNormalDir = outputCacheLocalDir {
                    let cmdUrl = outputNormalDir
                        .appendingPathComponent("_logs_")
                        .appendingPathComponent(cmdValue, isDirectory: false)
                    return (cmdKey: cmdKey, cmdUrl: cmdUrl, cmdValue: cmdValue)
                } else {
                    let cmdUrl = languagesUrl
                        .deletingLastPathComponent() // Languages
                        .appendingPathComponent("_CACHE__LOCAL")
                        .appendingPathComponent(cmdValue, isDirectory: false)
                    return (cmdKey: cmdKey, cmdUrl: cmdUrl, cmdValue: cmdValue)
                }
            } else if cmdKey == "OUTPUT_CACHE_LOCAL_DIR" {
                let dirname = "\(cmdValue)_\(Date.datestampyyyyMMddHHmm)"
                let cmdUrl = languagesUrl
                    .deletingLastPathComponent() // Languages
                    .appendingPathComponent("_CACHE__LOCAL")
                    .appendingPathComponent(dirname, isDirectory: true)
                return (cmdKey: cmdKey, cmdUrl: cmdUrl, cmdValue: cmdValue)
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
                return (cmdKey: cmdKey, cmdUrl: cmdUrl, cmdValue: cmdValue) 
            } else if cmdKey == "CS_DELETE_KEY" || cmdKey == "CS_INSERT_KEY" {
                return (cmdKey: cmdKey, cmdUrl: nil, cmdValue: cmdValue) 
            } else {
                let cmdUrl = languagesUrl.appendingPathComponent(cmdValue)
                return (cmdKey: cmdKey, cmdUrl: cmdUrl, cmdValue: cmdValue)
            }
        }
        else { // parts.count > 2
            print("ERROR:B: Too many line `parts`. Did not process: '\(line)'")
            return nil
        }
    }
    
}
