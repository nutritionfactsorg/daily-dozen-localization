//
//  BatchNormal.swift
//  
//

import Foundation

struct BatchNormal {
    
    static var shared = BatchNormal()
    let logger = LogService.shared
    
    /// normalizes `*.strings` only
    func doNormalize(sourceStrings: [URL], resultsDir: URL) {
        guard sourceStrings.count > 0, let stringsFirstUrl = sourceStrings.first else {
            print("ERROR: sourceStrings is an empty list")
            return
        }
        
        // to normalized *.strings files
        // …/App/InfoPlist/en.lproj/InfoPlist.strings"
        let langCode = stringsFirstUrl
            .deletingLastPathComponent() // *.strings
            .deletingPathExtension()     // .lproj
            .lastPathComponent           // en
        
        logger.info("\n##### DO_NORMALIZE_BATCH STRINGS LANGUAGE: \(langCode)")
        print("\n##### DO_NORMALIZE_BATCH STRINGS LANGUAGE: \(langCode)")
        
        var stringz = StringzProcessor()
        for url in sourceStrings {
            stringz.parse(url: url)
        }
        let stringsDictionary = stringz.toStringsSplitByFile(langCode: langCode)
        
        writeNormalStrings(stringsDictionary, langCode: langCode, resultsDir: resultsDir)
    }
    
    /// normalizes `*.tsv` and generates normalized `*.json`, `*.strings`, `*.xml`
    /// 
    /// - parameter sourceTSV: …[…/Portuguese_Brazil/tsv/Portuguese_pt-BR.app.tsv] (example)
    /// - parameter resultsDir: `…/_CACHE__LOCAL/StringsViaTsvIntake example` (example)
    /// - parameter baseJsonDir: …/English_US/ios/json/LocalStrings/en.lproj (example)
    /// - parameter baseListTsv: …/English_US/tsv/*.tsv `[URL]` (example)
    /// - parameter baseTsvUrlFragments: …/English_US/tsv/English_US_en.url_fragments.tsv (example)
    /// - parameter baseTsvUrlTopics: …/English_US/tsv/English_US_en.url_topics.tsv (example)
    /// - parameter baseXmlUrl: …/English_US/android/values/strings.xml (example)
    func doNormalize(sourceTSV: [URL], resultsDir: URL, baseJsonDir: URL, baseListTsv: [URL], baseTsvUrlFragments: URL, baseTsvUrlTopics: URL, baseXmlUrl: URL) {
        
        guard sourceTSV.count > 0, let tsvFirstUrl = sourceTSV.first else {
            print("ERROR: BatchNormal.doNormalize(…) sourceTSV is an empty list")
            return
        }
        let nameParts = getTsvFilenameParts(tsvFirstUrl)
        let langCode = nameParts.lang
        let modifier = nameParts.modifier
        
        let tsvLanguage = tsvFirstUrl.deletingPathExtension().lastPathComponent
        logger.info("##### DO_NORMALIZE_BATCH TSV LANGUAGE: \(tsvLanguage)\n")
        print("##### DO_NORMALIZE_BATCH TSV LANGUAGE: \(tsvLanguage)\n")
        //if 
        //    tsvLanguage.starts(with: "Catalan_ca") // ||
        // // tsvLanguage == "Catalan_ca.app" // ||
        // // tsvLanguage ==  "Catalan_ca.store" // ||
        // // tsvLanguage == "Spanish_es" // ||
        //{ 
        //    print(":WATCH:BatchNormal:TSV: \(tsvLanguage)")
        //}
        
        // ----- to TSV -----
        // Base Language TSV (English_US)
        let baseTsvSheet =  TsvSheet(urlList: baseListTsv)
        // Base URL Fragments TSV (specified: English_US (default) or langauge specific)
        var baseUrlFragmentsSheet = TsvSheet(urlList: [baseTsvUrlFragments])
        baseUrlFragmentsSheet.updateBaseNotes(baseTsvSheet)
        baseUrlFragmentsSheet.updateBaseValues(baseTsvSheet)
        
        // Base URL Topics TSV (specified: English_US (default) or langauge specific)
        var baseUrlTopicsSheet = TsvSheet(urlList: [baseTsvUrlTopics])
        baseUrlTopicsSheet.updateBaseNotes(baseTsvSheet)
        baseUrlTopicsSheet.updateBaseValues(baseTsvSheet)
        
        // Source TSV
        var sourceSheet = TsvSheet(urlList: sourceTSV)
        sourceSheet.updateBaseNotes(baseTsvSheet)
        sourceSheet.updateBaseValues(baseTsvSheet)
        writeNormalTsv(sourceSheet, urlTsvIn: tsvFirstUrl, resultsDir: resultsDir)
        
        // ----- to *.TSV -----
        // add url topic links
        let forTsvSheet = TsvSheet([sourceSheet, baseUrlFragmentsSheet, baseUrlTopicsSheet])
        let forTsvUrl = sourceTSV[0]
            .deletingLastPathComponent()
            .appendingPathComponent("all\(modifier).tsv", isDirectory: false)
        writeNormalTsv(forTsvSheet, urlTsvIn: forTsvUrl, resultsDir: resultsDir)
        
        if tsvLanguage.contains("appstore") || tsvLanguage.contains("url_fragments") || tsvLanguage.contains("url_topics") {
            return
        }
        
        // must have `.app` modifier, not `.store` modifier
        if modifier.starts(with: ".app") == false {
            return
        }
        
        // ----- to /Localizable.strings -----
        // Apple *.strings uses url fragments
        let forStringsSheet = TsvSheet([sourceSheet, baseUrlFragmentsSheet])
        let stringz = StringzProcessor(tsvRowList: forStringsSheet.tsvRowList)
        let stringsDictionary = stringz.toStringsSplitByFile(langCode: langCode)
        
        writeNormalStrings(stringsDictionary, langCode: langCode, modifier: modifier, resultsDir: resultsDir)
        
        // ----- to JSON -----
        // Apple *.json uses url topic subpaths
        let forJsonSheet = TsvSheet([sourceSheet, baseUrlTopicsSheet])        
        let jsonOutputDir = resultsDir
            .appendingPathComponent("App")
            .appendingPathComponent("Texts")
            .appendingPathComponent("LocalStrings")
            .appendingPathComponent("\(langCode).lproj", isDirectory: true)
        var jsonFromTsv = JsonFromTsvProcessor(
            jsonBaseDir: baseJsonDir, 
            jsonOutputDir: jsonOutputDir)
        jsonFromTsv.processTsvToJson(tsvSheet: forJsonSheet)
        jsonFromTsv.writeJsonFiles()
        
        // ----- to XML -----
        let isEnglishUS = langCode == "en"
        let valuesPathFragment = isEnglishUS ? "values" : "values-\(langCode)"
        let xmlOutputUrl = resultsDir
            .appendingPathComponent("res_android")
            .appendingPathComponent(valuesPathFragment)
            .appendingPathComponent("strings.xml", isDirectory: false)
        
        let tsvForXmlSheet = TsvSheet([sourceSheet, baseUrlFragmentsSheet, baseUrlTopicsSheet])     
        
        let droidLookup = tsvForXmlSheet.getLookupDictLangValueByAndroidKey()
        var xmlFromTsv = XmlFromTsvProcessor(lookupTable: droidLookup)
        do {
            let droidXmlDocument = try XMLDocument(
                contentsOf: baseXmlUrl, 
                options: [.nodePreserveAll, .nodePreserveWhitespace])
            xmlFromTsv.processXmlFromTsv(
                droidXmlOutputUrl: xmlOutputUrl, 
                baseXmlDocument: droidXmlDocument, 
                keepNontranslatable: isEnglishUS
            )
        } catch {
            print("ERROR: doNormalize: baseXmlUrl failed to read \(baseXmlUrl.path) \(error)")
            return
        }
    }
    
    /// Pattern: `FILE_NAME_LANG-REGION.lang-modifier.date-modifier.tsv`
    /// Examples:
    ///     `Spanish_es.app.20210309.tsv`
    ///     `Chinese_Traditional_zh-Hant.store.20201028.tsv`
    private func getTsvFilenameParts(_ url: URL) -> (lang: String, modifier: String, name: String) {
        var langStr = ""
        var modifierStr = ""
        var nameStr = ""
        
        let basename = url
            .deletingPathExtension() // .tsv
            .lastPathComponent
        
        let dotParts = basename.components(separatedBy: ".")
        for i in 1 ..< dotParts.count {
            modifierStr.append(".\(dotParts[i])")
        }
        
        var underscoreParts = dotParts[0].components(separatedBy: "_")
        langStr = underscoreParts.removeLast()
        nameStr = underscoreParts.joined(separator: "_")
        
        return (langStr, modifierStr, nameStr)
    }
    
    /// Example:
    ///     `Bulgarian/android/values-bg/strings.xml`
    private func getXmlFilenameParts(_ url: URL) -> (lang: String, code: String) {
        let langStr = url
            .deletingLastPathComponent() // strings.xml
            .deletingLastPathComponent() // values-lang
            .deletingLastPathComponent() // android
            .lastPathComponent           // Bulgarian
        
        let valuesLangcode = url
            .deletingLastPathComponent() // strings.xml
            .lastPathComponent           // values-langcode
        let parts = valuesLangcode.components(separatedBy: "-")
        let langcodeStr = parts.count > 1 ? parts[1] : "en"
        
        return (langStr, langcodeStr)
    }
    
    /// XLIFF to normalized `*.strings` file
    /// 
    /// Note: input `en.xliff` has output `en.normal.strings`
    func doNormalize(sourceXLIFF: URL, resultsDir: URL) {
        logger.info("\n##### DO_NORMALIZE_BATCH XLIFF")
        print("\n##### DO_NORMALIZE_BATCH XLIFF")
        // to TSV
        let xliff = XliffIntoTsvProcessor(url: sourceXLIFF)
        
        // to normalized *.strings files
        let langCode = sourceXLIFF
            .deletingPathExtension() // .xliff
            .lastPathComponent       // en
        
        let stringz = StringzProcessor(tsvRowList: xliff.tsvRowList)
        let stringsDictionary = stringz.toStringsSplitByFile(langCode: langCode)
        
        writeNormalStrings(stringsDictionary, langCode: langCode, resultsDir: resultsDir)
    }
    
    // :NYI: does not yet support adding URL components to Android `strings.xml` files
    func doNormalize(
        sourceXml: URL,     /// target language `Languages/…/strings.xml`
        resultsDir: URL, 
        baseListTsv: [URL], 
        //baseTsvUrlFragments: URL, 
        //baseTsvUrlTopics: URL, 
        baseXmlUrl: URL
    ) {
        
        let tsvLanguage = sourceXml
            .deletingLastPathComponent() // "strings.xml"
            .deletingLastPathComponent() // "values-lang"
            .deletingLastPathComponent() // "android"
            .lastPathComponent // "Bulgarian"
        logger.info("\n##### DO_NORMALIZE_BATCH XML LANGUAGE: \(tsvLanguage)")
        print("\n##### DO_NORMALIZE_BATCH XML LANGUAGE: \(tsvLanguage)")
        if tsvLanguage == "Bulgarian" {
            print(":WATCH:BatchNormal:XML: \(tsvLanguage)")
        }
        
        // ----- to TSV -----
        // Base Language TSV (English_US)
        let baseTsvSheet =  TsvSheet(urlList: baseListTsv)
        
        // Base URL Fragments TSV
        //var baseUrlFragmentsSheet = TsvSheet(urlList: [baseTsvUrlFragments])
        //baseUrlFragmentsSheet.updateBaseNotes(baseTsvSheet)
        //baseUrlFragmentsSheet.updateBaseValues(baseTsvSheet)
        //writeNormalTsv(baseUrlFragmentsSheet, urlTsvIn: baseTsvUrlFragments, resultsDir: resultsDir)
        
        // Base URL Topics TSV
        //var baseUrlTopicsSheet = TsvSheet(urlList: [baseTsvUrlTopics])
        //baseUrlTopicsSheet.updateBaseNotes(baseTsvSheet)
        //baseUrlTopicsSheet.updateBaseValues(baseTsvSheet)
        //writeNormalTsv(baseUrlTopicsSheet, urlTsvIn: baseTsvUrlTopics, resultsDir: resultsDir)
        
        let nameParts = getXmlFilenameParts(sourceXml)
        let langName = nameParts.lang
        let langCode = nameParts.code
        let isEnglishUS = langName == "English_US"
        //let valuesPathFragment = isEnglishUS ? "values" : "values-\(langCode)"
        
        // ----- from XML into intermediate (normalized) TSV -----      
        let xmlIntoTsvProcessor = XmlIntoTsvProcessor(
            url: sourceXml, 
            baseOrLang: .langMode)
        let migrationTsvList = applyAndroidLanguage(
            basis: baseTsvSheet.tsvRowList, 
            addin: xmlIntoTsvProcessor.tsvRowList
        )
        let migrationSheet = TsvSheet(tsvRowList: migrationTsvList)
        writeNormalTsv(migrationSheet, urlXmlIn: sourceXml, resultsDir: resultsDir)
        
        // ----- from intermediate TSV into XML -----
        let valuesPathFragment = isEnglishUS ? "values" : "values-\(langCode)"
        let xmlOutputUrl = resultsDir
            .appendingPathComponent("android-processed")
            .appendingPathComponent(valuesPathFragment)
            .appendingPathComponent("strings.xml", isDirectory: false)
        
        let droidLookup = migrationSheet.getLookupDictLangValueByAndroidKey()
        var xmlFromTsvProcessor = XmlFromTsvProcessor(lookupTable: droidLookup)
        do {
            let baseXmlDocument = try XMLDocument(
                contentsOf: baseXmlUrl, 
                options: [.nodePreserveAll, .nodePreserveWhitespace])
            xmlFromTsvProcessor.processXmlFromTsv(
                droidXmlOutputUrl: xmlOutputUrl, 
                baseXmlDocument: baseXmlDocument, 
                keepNontranslatable: isEnglishUS
            )
        } catch {
            print("ERROR: doNormalize: baseXmlUrl failed to read \(baseXmlUrl.path) \(error)")
            return
        }
    }
    
    /// apply in language values `lang_value`. used for xml.
    func applyAndroidLanguage(basis: TsvRowList, addin: TsvRowList) -> TsvRowList {
        var mergeResult = TsvRowList()
        var missingMergeKeys = [String]()
        
        let basisRows = basis.sortedByAndroid().data
        let addinRows = addin.sortedByAndroid().data
        
        var i = 0
        var j = 0
        while i < basisRows.count && j < addinRows.count {
            let basisKey = basisRows[i].key_android
            let addinKey = addinRows[j].key_android
            if basisKey == addinKey {
                var r = basisRows[i]
                r.lang_value = addinRows[j].lang_value
                mergeResult.append(r)
                i += 1
                j += 1
            } else if basisKey < addinKey {
                mergeResult.append(basisRows[i])
                i += 1
            } else {
                missingMergeKeys.append(addinRows[j].key_android)
                j += 1
            }            
        }
        while i < basisRows.count {
            mergeResult.append(basisRows[i])
            i += 1
        }
        while j < addinRows.count {
            missingMergeKeys.append(addinRows[j].key_android)
            j += 1
        }
        
        if missingMergeKeys.isEmpty == false {
            var msg = """
            \n#################################################################
            ### REPORT: TsvSheet applyAndroidLanguage missing key_android ###
            #################################################################\n
            """
            for s in missingMergeKeys {
                msg.append("\(s)\n")
            }
            logger.info(msg)
        }
        
        return mergeResult
    }
    
    private func writeNormalStrings(
        _ stringsDictionary: [StringzProcessor.SplitFile : String], 
        langCode: String,
        modifier: String = "", 
        resultsDir: URL) {
            for (key, content) in stringsDictionary {
                var outputDirUrl = resultsDir
                for pathComponent in key.stringsPathComponents {
                    outputDirUrl.appendPathComponent(pathComponent, isDirectory: true)
                }
                outputDirUrl.appendPathComponent("\(langCode).lproj", isDirectory: true)
                var fname = "\(key.stringsFilename)\(modifier).strings"
                if modifier == ".app" {
                    fname = "\(key.stringsFilename).strings"
                }
                let outputFileUrl = outputDirUrl
                    .appendingPathComponent(fname, isDirectory: false)
                
                do {
                    try FileManager.default.createDirectory(
                        at: outputDirUrl,
                        withIntermediateDirectories: true, 
                        attributes: nil)
                    try content.write(to: outputFileUrl, atomically: false, encoding: .utf8)
                } catch {
                    print("ERROR: failed to write \(outputFileUrl.path) \(error)")
                }
            }
        }
    
    private func writeNormalTsv(_ tsvSheet: TsvSheet, urlTsvIn: URL, resultsDir: URL) {
        let tsvFilename = urlTsvIn.lastPathComponent
        let tsvLangName = urlTsvIn
            .deletingLastPathComponent() // filename.tsv
            .deletingLastPathComponent() // tsv
            .lastPathComponent           // language name e.g. English_US
        let outputTsvDirUrl = resultsDir
            .appendingPathComponent("Languages_tsv_normal")
            .appendingPathComponent(tsvLangName)
            .appendingPathComponent("tsv")
        let outputTsvFileUrl = outputTsvDirUrl
            .appendingPathComponent(tsvFilename, isDirectory: false)
        do {
            try FileManager.default.createDirectory(
                at: outputTsvDirUrl,
                withIntermediateDirectories: true, 
                attributes: nil)
            tsvSheet.writeTsvFile(fullUrl: outputTsvFileUrl)            
        } catch {
            print("ERROR: failed to write \(outputTsvFileUrl.path) \(error)")
        }
    }
    
    private func writeNormalTsv(_ tsvSheet: TsvSheet, urlXmlIn: URL, resultsDir: URL) {
        let language = urlXmlIn
            .deletingLastPathComponent() // strings.xml
            .deletingLastPathComponent() // values-langcode
            .deletingLastPathComponent() // android
            .lastPathComponent           // Chinese_Traditional
        
        let valuesLangcode = urlXmlIn
            .deletingLastPathComponent() // strings.xml
            .lastPathComponent           // values-langcode
        let parts = valuesLangcode.components(separatedBy: "-")
        let langcode = parts.count > 1 ? parts[1] : "en"
        
        let tsvFilename = "\(language)_\(langcode).tsv"
        let outputTsvDirUrl = resultsDir
            .appendingPathComponent("Languages_tsv_normal")
            .appendingPathComponent(language)
            .appendingPathComponent("tsv")
        let outputTsvFileUrl = outputTsvDirUrl
            .appendingPathComponent(tsvFilename, isDirectory: false)
        do {
            try FileManager.default.createDirectory(
                at: outputTsvDirUrl,
                withIntermediateDirectories: true, 
                attributes: nil)
            tsvSheet.writeTsvFile(fullUrl: outputTsvFileUrl)            
        } catch {
            print("ERROR: failed to write \(outputTsvFileUrl.path) \(error)")
        }
    }
    
    // MARK: - Insert Normalized TSV Files
    
    /// Caveats: initial implementation has the following limitations
    /// - single file to merge into a base file
    /// - based on `key_apple`
    func doInsetTsv(sourceTSV: [URL], resultsDir: URL) {
        guard sourceTSV.count > 1 else {
            fatalError("BatchNormal doMerge requires at least 2 source file urls")
        }
        guard sourceTSV.count == 2 else {
            fatalError(":NYI: doInset(tsvRow: TsvRow) is only implemented for 2 TSV files.")
        }        
        var baseTsvSheet = TsvSheet(sourceTSV[0])
        let insetTsvSheet = TsvSheet(sourceTSV[1])
        
        for tsvRow in insetTsvSheet.tsvRowList.data {
            baseTsvSheet.doInset(addTsvRow: tsvRow)
        }
        
        let filename = sourceTSV[0].deletingPathExtension().lastPathComponent
        let outUrl = resultsDir.appending(component: "\(filename).inset.tsv", directoryHint: .notDirectory)
        
        baseTsvSheet.writeTsvFile(fullUrl: outUrl)
        
        print("doInsetTsv completed")
    }
    
}
