//
//  AppLocalizer.swift
//  AppLocalizerLib
//

import Foundation

public final class AppLocalizer {
    private let streamErr: StandardErrorStream
    private let streamOut: StandardOutputStream
    
    public static let environmentInfo = ProcessInfo().environment
    // Path to Android app/src/main/res
    public static var environmentNFAndroidResources = ProcessInfo().environment["NF_ANDROID_RESOURCES"]
    // Path to daily-dozen-localization/Languages
    public static var environmentNFLanguages = ProcessInfo().environment["NF_LANGUAGES"]
    
    var directoryLib: URL {
        #if os(macOS)
        return Bundle.main.bundleURL
        #else
        return Bundle.main.bundleURL
        #endif
    }
    
    public init() {
        self.streamErr = StandardErrorStream()
        self.streamOut = StandardOutputStream()
        print("directoryLib='\(directoryLib.path)'")
    }
    
    /// BatchRunner(commandsUrl:languagesUrl:mappingsUrl)
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

