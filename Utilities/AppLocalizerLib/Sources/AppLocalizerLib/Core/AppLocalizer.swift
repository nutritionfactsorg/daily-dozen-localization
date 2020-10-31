//
//  AppLocalizer.swift
//  AppLocalizerLib
//

import Foundation

public final class AppLocalizer {
    let job: BatchJob
    private let streamErr: StandardErrorStream
    private let streamOut: StandardOutputStream
    
    var directoryLib: URL {
        // :DEBUG: Bundle.allBundles .bundlePath .resourcePath
        var i = 0
        for bundle in Bundle.allBundles {
            print("*** LIB bundle A [\(i)]")
            print("bundle.bundlePath=\(bundle.bundlePath)")
            print("bundle.executablePath=\(bundle.executablePath ?? "no executable path")")
            print("bundle.resourcePath=\(bundle.resourcePath ?? "no resource path")")
            i += 1
        }
        #if os(macOS)
        for bundle in Bundle.allBundles {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError(":ERROR: couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }
    
    public init(job: BatchJob) {
        // :DEBUG: Bundle.allBundles .bundlePath .resourcePath
        var i = 0
        for bundle in Bundle.allBundles {
            print("*** lib bundle B [\(i)]")
            print("bundle.bundlePath=\(bundle.bundlePath)")
            print("bundle.executablePath=\(bundle.executablePath ?? "no executable path")")
            print("bundle.resourcePath=\(bundle.resourcePath ?? "no resource path")")
            i += 1
        }

        self.job = job
        self.streamErr = StandardErrorStream()
        self.streamOut = StandardOutputStream()
        print("directoryLib='\(directoryLib)'")


    }
    
    public func run() throws {
        streamOut.write("*****************************************\n")
        streamOut.write("*** :BEGIN: AppLocalizer run()        ***\n")
        streamOut.write("*****************************************\n")
        streamOut.write("droidBaseXmlInputUrl = \(job.droidBaseXmlInputUrl.path)\n")
        streamOut.write("droidLangXmlInputUrl = \(job.droidLangXmlInputUrl.path)\n")
        streamOut.write("appleLangXliffInputUrl = \(job.appleLangXliffInputUrl.path)\n")
        
        processDetails()
        //processXliff()
    }
    
    /// Generate new DozeDetails.json, TweakDetails.json files
    private func processDetails() {
        streamOut.write("*** processDetails DozeDetails.json\n") // :!!!:NYI
        var dozeDetailsProcessor = DozeDetailsProcessor()
        dozeDetailsProcessor.readData(droidUrl: job.droidBaseXmlInputUrl, isBaseLanguage: true)
        dozeDetailsProcessor.readData(droidUrl: job.droidLangXmlInputUrl, isBaseLanguage: false)
        
        var str = dozeDetailsProcessor.toStringTsv()
        //dozeDetailsProcessor.writeTsv(url: job.tsvDozeDetailsUrl)
        
        // :NYI:!!!: have separate workflow for reading in file after translator review
        // dozeDetailsProcessor.readTsv(url: tsvDozeDetailsUrl)
        // dozeDetailsProcessor.writeJson(url: job.appleBaseDozeJsonInputUrl)
        
        streamOut.write("*** processDetails TweakDetails.json\n")
        var tweaksDetailsProcessor = TweakDetailsProcessor()
        tweaksDetailsProcessor.readData(droidUrl: job.droidBaseXmlInputUrl, isBaseLanguage: true)
        tweaksDetailsProcessor.readData(droidUrl: job.droidLangXmlInputUrl, isBaseLanguage: false)
        str.append(tweaksDetailsProcessor.toStringTsv(includeHeader: false))
        
        try! str.write(to: job.tsvExportUrl, atomically: false, encoding: String.Encoding.utf8)
        
        //tweaksDetailsProcessor.writeTsv(url: job.tsvTweakDetailsUrl)
        
        
        // :NYI:!!!: have separate workflow for reading in file after translator review
        //tweaksDetailsProcessor.readTsv(url: tsvTweakDetailsUrl)
        //tweaksDetailsProcessor.writeJson(url: job.appleBaseTweakJsonInputUrl)
    }
    
    /// Write values to existing XLIFF file
    private func processXliff() {
        streamOut.write("*** processXliff\n")
        let droidUrl = job.droidLangXmlInputUrl
        let xliffUrl = job.appleLangXliffInputUrl
        
        guard
            let droidXML = try? XMLDocument(contentsOf: droidUrl, options: []),
            let droidRootElement = droidXML.rootElement(),
            let _ = droidRootElement.children, // :!!!: droidL2NodeList: [XMLNode]
            let xliffXML = try? XMLDocument(contentsOf: xliffUrl, options: []),
            let xliffRootElement = xliffXML.rootElement(),
            let _ = xliffRootElement.children // :!!!: allXliffXmlNodes: [XMLNode]
        else { 
            streamErr.write("Failed to prepare processXliff input files")
            return
        }
    }
    
}

public extension AppLocalizer {
    enum Error: Swift.Error {
        case missingArgument
        case failedToDoSomething
    }
}

