//
//  AppLocalizer.swift
//  AppLocalizerLib
//

import Foundation

public final class AppLocalizer {
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
    
    public init() {
        // :DEBUG: Bundle.allBundles .bundlePath .resourcePath
        var i = 0
        for bundle in Bundle.allBundles {
            print("*** lib bundle B [\(i)]")
            print("bundle.bundlePath=\(bundle.bundlePath)")
            print("bundle.executablePath=\(bundle.executablePath ?? "no executable path")")
            print("bundle.resourcePath=\(bundle.resourcePath ?? "no resource path")")
            i += 1
        }
        
        self.streamErr = StandardErrorStream()
        self.streamOut = StandardOutputStream()
        print("directoryLib='\(directoryLib)'")
    }
    
    public func run(commandsUrl: URL, languagesUrl: URL, mappingsUrl: URL) {
        var batch = BatchRunner(
            commandsUrl: commandsUrl, 
            languagesUrl: languagesUrl, 
            mappingsUrl: mappingsUrl
        )
        batch.run()
    }
    
}

public extension AppLocalizer {
    enum Error: Swift.Error {
        case missingArgument
        case failedToDoSomething
    }
}

