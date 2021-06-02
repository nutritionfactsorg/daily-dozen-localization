import Foundation
import XCTest

// testable attribute allows access to `internal` scope items for internal framework testing.
@testable 
import UrlCheckLib

final class UrlCheckTests: XCTestCase {
    
    func testUrlCheckLib() throws {
        print("\n## testUrlCheckLib() ##")
        
        // Create an instance of the command line tool framework
        var arguments = [String]()
        arguments.append("-flag")
        arguments.append("--param1=value1")
        arguments.append(contentsOf: ["--param2=value2", "-other-flag"])
        let tool = UrlCheck(arguments: arguments)
        
        // Run the tool and assert that the file was created
        do {
            try tool.run()
            
            // Check some outcome
            //XCTAssertNotNil(try? testFolder.file(named: "Hello.swift"))
        } catch {
            throw UrlCheck.Error.failedToDoSomething
        }
        print("#####\n")
    }
    
    //func terminationExample(process: Process, expectation: XCTestExpectation) {
    //    DispatchQueue.main.async {
    //        print("•••ENTER••• terminationExample dispatch")
    //        let taskStatus = process.terminationStatus
    //
    //        if (taskStatus == 0) {
    //            debugPrint("Pass: terminationExample() task completed sucessfully!")
    //            expectation.fulfill()
    //        } else {
    //            debugPrint("Fail: terminationExample() task did not complete.")
    //        }
    //        print("•••EXIT••• terminationExample dispatch")
    //    }
    //}
    
    //func testExecutable() throws {
    //    print("\n######################")
    //    print("## testExecutable() ##")
    //    print("######################")
    //
    //    // Some APIs used require macOS 10.13 and above.
    //    guard #available(macOS 10.13, *) else {
    //        return
    //    }
    //
    //    // Create an expectation for a background task.
    //    let expectation = XCTestExpectation(description: "Some background task.")
    //
    //    // build products directory
    //    let executableUrl = productsDirectory.appendingPathComponent("UrlCheckTool")
    //
    //    // https://developer.apple.com/documentation/foundation/process
    //    let process = Process()
    //    process.executableURL = executableUrl
    //
    //    var arguments = [String]()
    //    arguments.append("-flag")
    //    arguments.append("--param1=value1")
    //    arguments.append(contentsOf: ["--param2=value2", "-other-flag"])
    //    process.arguments = arguments
    //
    //    process.terminationHandler = {
    //        (task: Process) -> Void in
    //        print("•••ENTER••• terminationHandler")
    //        self.terminationExample(process: task, expectation: expectation)
    //        print("•••EXIT••• terminationHandler")
    //    }
    //
    //    let stdoutPipe = Pipe()
    //    process.standardOutput = stdoutPipe
    //    let stderrPipe = Pipe()
    //    process.standardError = stderrPipe
    //
    //    try process.run()
    //
    //    let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
    //    if let stdoutStr = String(data: stdoutData, encoding: .utf8) {
    //        print("\n## stdOutput\n\(stdoutStr)")
    //        XCTAssert(stdoutStr.contains("Hello"))
    //    }
    //    else {
    //        throw UrlCheck.Error.failedToDoSomething
    //    }
    //
    //    let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
    //    if let stderrStr = String(data: stderrData, encoding: String.Encoding.utf8) {
    //        print("\n## stdError\n\(stderrStr)")
    //    }
    //    else {
    //        throw UrlCheck.Error.failedToDoSomething
    //    }
    //
    //    process.waitUntilExit()
    //    let status: Int32 = process.terminationStatus
    //    print("## TERMINATION STATUS: \(status)")
    //
    //    let reason: Process.TerminationReason = process.terminationReason
    //    print("## TERMINATION REASON: \(reason.rawValue) (.exit==1, .uncaughtSignal==2)")
    //
    //    // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
    //    wait(for: [expectation], timeout: 10.0)
    //    print("#####\n")
    //}
        
    /// Returns path to the build products directory.
    var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError(":ERROR:TEST: couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }
    
    func testProductsDirectory() {
        print("\n#############################")
        print(  "## testProductsDirectory() ##")
        print(  "#############################\n")
        
        print("productsDirectory = '\(productsDirectory)'")
        
        print(":TEST: Bundle.moduleDir=\(Bundle.resourceModuleDir)")
        print(":TEST: Bundle.module=\(Bundle.module)")

        print("#####\n")
    }
    
    static var allTests = [
        ("testProductsDirectory", testProductsDirectory),
        ("testUrlCheckLib", testUrlCheckLib),
        //("testExecutable", testExecutable),
    ]
}
