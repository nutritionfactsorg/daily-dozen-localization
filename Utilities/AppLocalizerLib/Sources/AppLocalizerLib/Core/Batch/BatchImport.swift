//
//  BatchImport.swift
//  AppLocalizerLib
//

import Foundation

struct BatchImport {
    static var shared = BatchImport() 
    
    // Data Processors 
    var _jsonProcessor: JsonFromTsvProcessor!  // key_apple    
    var _tsvImportSheet: TsvSheet!
    var _xliffProcessor: XliffFromTsvProcessor!
    var _xmlProcessor: XmlFromTsvProcessor!
    
    mutating func clearAll() {
        _jsonProcessor = nil    
        _tsvImportSheet = nil
        _xliffProcessor = nil
        _xmlProcessor = nil
    }
    
    mutating func doImport(
        sourceTSV: [URL], 
        outputAndroid: URL?, 
        outputApple: URL?
    ) {
        print("""
        ### DO_IMPORT_TSV doImport() ###
               inputTSV = \(sourceTSV)
          outputAndroid = \(outputAndroid?.absoluteString ?? "nil")
            outputApple = \(outputApple?.absoluteString ?? "nil")
        """)
        
        // 1. TSV Input File
        _tsvImportSheet = TsvSheet(urlList: sourceTSV, loglevel: .info)
        
        // 2. Process Apple JSON Files
        if let appleXmlUrl = outputApple {
            _jsonProcessor = JsonFromTsvProcessor(xliffUrl: appleXmlUrl)
            _jsonProcessor.processTsvToJson(tsvSheet: _tsvImportSheet)
            _jsonProcessor.writeJsonFiles()
        }
        
        // 3. Process Apple XLIFF XMLDocument
        if 
            let appleXmlUrl = outputApple,
            let appleXmlDocument = try? XMLDocument(contentsOf: appleXmlUrl, options: [.nodePreserveAll]),
            let appleRootXMLElement: XMLElement = appleXmlDocument.rootElement() {
            _xliffProcessor = XliffFromTsvProcessor(lookupTable: _tsvImportSheet.getLookupDictLangValueByAppleKey())
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
            let lookupTable: [String: String] = _tsvImportSheet.getLookupDictLangValueByAndroidKey()
            _xmlProcessor = XmlFromTsvProcessor(lookupTable: lookupTable)
            let droidXmlOutputUrl = droidXmlUrl
                .deletingPathExtension()
                .appendingPathExtension("\(Date.datestampyyyyMMddHHmm).xml")
            _xmlProcessor.processXmlFromTsv(
                droidXmlOutputUrl: droidXmlOutputUrl, 
                baseXmlDocument: droidXmlDocument, 
                keepNontranslatable: true
            )
            // file writing included in `processXmlFromTsv(…)`
        }
                
        // 5. Write Report
        Reporter.shared.writeReport(batchImport: self)
        Reporter.shared.writeReport(batchImport: self, verbose: true)
    }
    
}
