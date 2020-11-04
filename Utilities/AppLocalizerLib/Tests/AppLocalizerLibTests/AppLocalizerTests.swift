import Foundation
import XCTest

import class Foundation.Bundle
// testable attribute allows access to `internal` scope items for internal framework testing.
@testable 
import AppLocalizerLib

final class AppLocalizerTests: XCTestCase {
    
    /// Test AppLocalizerLib directly.
    func testAppLocalizerLib() {
        guard #available(macOS 10.15, *) else { return }
        
        // …/AppLocalizerLibTests.bundle/Resources/commands_a.txt
        // Content: batch commands file
        let commandsDir = productsDir
            .appendingPathComponent("AppLocalizerLibTests.bundle")
            .appendingPathComponent("Resources", isDirectory: true)
        let commandsFile = commandsDir
            .appendingPathComponent("commands_import.txt", isDirectory: false)
            //.appendingPathComponent("commands_a.txt", isDirectory: false)
        print("commandsDir=\(commandsDir.absoluteString)")
        print("commandsFile=\(commandsFile.absoluteString)")
        
        // …/AppLocalizerLibTests.bundle/Languages/ 
        // copy from daily-dozen-localization/Languages
        //  e.g. Languages/Spanish/android/, …ios/, …tsv/
        let languagesDir = productsDir
            .appendingPathComponent("AppLocalizerLibTests.bundle")
            .appendingPathComponent("Languages", isDirectory: true)
        print("languagesDir=\(languagesDir.absoluteString)")
        
        // …/AppLocalizerLib.bundle/Resources/ …Doze/ and …Tweak/
        // Content: Android <--> Apple mapping files 
        let mappingsDir = productsDir
            .appendingPathComponent("AppLocalizerLib.bundle")
            .appendingPathComponent("Resources", isDirectory: true)
        print("mappingsDir=\(mappingsDir.absoluteString)")
        
        let batch = BatchRunner(
            commandsUrl: commandsFile, 
            languagesUrl: languagesDir, 
            mappingsUrl: mappingsDir
        )
        batch.run()
    }
    
    /// :NYI: Exercise the CLI AppLocalizerTool 
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
    
    static var allTests = [
        ("testProductsDirectory", testProductsDirectory),
        ("testAppLocalizerLib", testAppLocalizerLib),
        //("testAppLocalizerTool", testAppLocalizerTool),
    ]
}
