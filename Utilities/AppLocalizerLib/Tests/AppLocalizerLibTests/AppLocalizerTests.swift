import Foundation
import XCTest

import class Foundation.Bundle
// testable attribute allows access to `internal` scope items for internal framework testing.
@testable 
import AppLocalizerLib

final class AppLocalizerTests: XCTestCase {
    
    // batch_diff_xliff.yaml
    // batch_diff_tsv_update_af.yaml
    // batch_diff_tsv_update__all.yaml
    // batch_export_es.yaml
    // batch_export_pl_es.yaml
    // batch_import_es.yaml
    // batch_import_pl.yaml
    // batch_import_de.yaml: de, pl 
    let commandSet = "batch_export_es.yaml"
    
    /// Test AppLocalizerLib directly.
    func testAppLocalizerLib() {

        guard #available(macOS 10.15, *) else {
            XCTFail("testAppLocalizerLib() requires macOS 10.15 or higher")
            return 
        }
        
        // Content: batch commands file
        // …/AppLocalizerLibTests.bundle/Resources/commands_*.txt
        //let commandsDir = productsDir
        //    .appendingPathComponent("AppLocalizerLibTests.bundle")
        //    .appendingPathComponent("Resources", isDirectory: true)
        // …/AppLocalizerLib_AppLocalizerLibTests.bundle/
        //     Contents/Resources/Resources/batch_export_es.yaml
        let commandsDir = productsDir
            .appendingPathComponent("AppLocalizerLib_AppLocalizerLibTests.bundle")
            .appendingPathComponent("Contents", isDirectory: true)
            .appendingPathComponent("Resources", isDirectory: true)
            .appendingPathComponent("Resources", isDirectory: true)
        let commandsFile = commandsDir
            .appendingPathComponent(commandSet, isDirectory: false)
        print("commandsDir=\(commandsDir.absoluteString)")
        print("commandsFile=\(commandsFile.absoluteString)")
        
        // …/AppLocalizerLibTests.bundle/Languages/ 
        // copy from daily-dozen-localization/Languages
        //  e.g. Languages/Spanish/android/, …ios/, …tsv/
        let languagesDir = productsDir
            .appendingPathComponent("AppLocalizerLib_AppLocalizerLibTests.bundle")
            .appendingPathComponent("Languages", isDirectory: true)
        print("languagesDir=\(languagesDir.absoluteString)")
        
        // …/AppLocalizerLib.bundle/Resources/ …Doze/ and …Tweak/
        // Content: Android <--> Apple mapping files 
        let mappingsDir = productsDir
            .appendingPathComponent("AppLocalizerLib.bundle")
            .appendingPathComponent("Resources", isDirectory: true)
        print("mappingsDir=\(mappingsDir.absoluteString)")
        
        var batch = BatchRunner(
            commandsUrl: commandsFile, 
            languagesUrl: languagesDir, 
            mappingsUrl: mappingsDir
        )
        batch.run()
    }
    
    // /////////////////////// //
    // XML Processing Routines //
    // /////////////////////// //
    
    // d1
    func createXMLDocumentFromFile(file: String) -> XMLDocument? {
        let furl = URL(fileURLWithPath: file)
        // `documentTidyXML` Also attempts to fix malformed XML
        let options: XMLNode.Options = [.documentTidyXML] 
        if let xmlDoc = try? XMLDocument(contentsOf: furl, options: options) {
            return xmlDoc
        } 
        return nil
    }
    
    // d2
    func createNewXMLDocument() {
        let root = XMLElement(name: "translations")
        let xmlDoc = XMLDocument(rootElement: root)
        xmlDoc.version = "1.0"
        xmlDoc.characterEncoding = "UTL-8"
        root.addChild(XMLElement(name: "language", stringValue:"fr"))
    }
    
    // e1
    func writeXmlToFile(xmlDoc: XMLDocument, fileUrl: URL) -> Bool {
        let xmlOptions: XMLNode.Options = [.nodePrettyPrint]
        let xmlData: Data = xmlDoc.xmlData(options: xmlOptions)
        
        let writingOptions: Data.WritingOptions = [.atomic]
        
        do {
            try xmlData.write(to: fileUrl, options: writingOptions)
        } catch {
            print("Could not write document out... \(error)")
            return false
        }        
        
        return true
    }
    
    // e2
    func previewXmlDoc(xmlDoc: XMLDocument) -> String {
        let options: XMLNode.Options = [.nodePrettyPrint]
        let displayString = xmlDoc.xmlString(options: options)
        return displayString
    }
    
    // e3
    func printXmlDoc(xmlDoc: XMLDocument) -> String? {
        let arguments: [String : String]? = nil
        var printDoc: XMLDocument? 
        
        let data = Data()
        if let anyDoc = try? xmlDoc.object(byApplyingXSLT: data, arguments: arguments),
           let transformedDoc = anyDoc as? XMLDocument {
            printDoc = transformedDoc
        }
        
        let xsltUrl = URL(fileURLWithPath: "xsltPath")
        if let anyDoc = try? xmlDoc.objectByApplyingXSLT(at: xsltUrl, arguments: arguments),
           let transformedDoc = anyDoc as? XMLDocument {
            printDoc = transformedDoc
        }
        
        let string = ""
        if let anyDoc = try? xmlDoc.object(byApplyingXSLTString: string, arguments: arguments),
           let transformedDoc = anyDoc as? XMLDocument {
            printDoc = transformedDoc
        } else { return nil }
        
        if let printDoc = printDoc {
            let options: XMLNode.Options = [.nodePrettyPrint]
            return printDoc.xmlString(options: options)
        } else {
            return nil
        }
    }
    
    // f1
    func walkXmlTree(xmlDoc: XMLDocument) {
        guard let aNode: XMLNode = xmlDoc.rootElement() else { return }
        var translatorNotes: String = ""
        
        while var aNode = aNode.next {
            if aNode.kind == .comment {
                if let stringValue = aNode.stringValue {
                    translatorNotes.append(stringValue)
                    translatorNotes.append(" ========> ")
                }
                
                if let nextNode = aNode.next {
                    aNode = nextNode
                    if let stringValue = aNode.stringValue {
                        // element to be translated
                        translatorNotes.append(stringValue)
                    }
                    translatorNotes.append("\n")
                }
            }
        }
        
        if translatorNotes.isEmpty == false {
            try? translatorNotes.write(toFile: "path/translator_notes.txt", atomically: true, encoding: String.Encoding.utf8)
        }
        
    }
    
    // ////////////////////////////////////////////////////////////////
    
    // // :NYI: Exercise the CLI AppLocalizerTool 
    //func testAppLocalizerTool() throws {        
    //    guard #available(macOS 10.15, *) else { return }
    //    
    //    let binaryUrl = productsDir.appendingPathComponent("AppLocalizerTool")
    //    print("binaryUrl='\(binaryUrl.absoluteString)'")
    //    
    //    let process = Process()
    //    process.executableURL = binaryUrl
    //    
    //    var arguments = [String]()
    //    arguments.append("SOME_KEY=SOME_VALUE")
    //    
    //    let pipe = Pipe()
    //    process.standardOutput = pipe
    //    
    //    try process.run()
    //    process.waitUntilExit()
    //    
    //    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    //    guard let output = String(data: data, encoding: .utf8) else { return }
    //    
    //    print("AppLocalizerTests testExample() output=\(output)")        
    //}
    
    /// Returns path to the built products directory.
    var productsDir: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError(":ERROR:TEST: build products directory `productsDir` not found")
        #else
        return Bundle.main.bundleURL
        #endif
    }
    
    /// Prints *.xctest product directory in context of all Bundle paths.
    func testProductsDirectory() {
        print("\n### testProductsDirectory() ###")
        var i = 0
        for bundle in Bundle.allBundles {
            print("# TEST_BUNDLE[\(i)]: \(bundle.bundlePath)")
            i += 1
        }
        
        print("# productsDir = '\(productsDir)'\n")
        #if os(macOS)
        XCTAssertEqual(productsDir.lastPathComponent, "Debug", "lastPathComponent != Debug")
        #else
        fatalError(":ERROR:TEST: NYI for non-macOS")
        #endif
    }
    
    
    func testSortHelper() {
        let sa = [
            "name02_11",
            "name.22",
            "name.3",
            "name.11",
            "name1_11",
            "name",
            "Name",
            "name02_10",
            "name2_10",
            "name2_09",
            "name0_00",
            "name-11",
            "naMe",
            "name-9",
            "name.2",
            "name.01",
            "name.",
            "name0",
            "name_"
        ]
        
        let sortHelper = SortHelper(sa)
        
        for element in sortHelper.elementArray {
            print(element.toString())
        }
                
        let result = sortHelper.sortWithUintPostfix()
        for string in result {
            print("\(string)")
        }
    }
    
}
