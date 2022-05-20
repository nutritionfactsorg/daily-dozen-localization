//
//  LogService.swift
//  DailyDozen
//
//  Copyright © 2020 Nutritionfacts.org. All rights reserved.
//

import Foundation

///
/// - Note: Be sure to set the "DEBUG" symbol in the compiler flags for the development build.
/// 
/// `Build Settings` > `All, Levels` > `Swift Compiler` - `Custom Flags/Other Swift Flags` >  
/// `(+) -D DEBUG`
public enum LogServiceLevel: Int, Comparable {
    case all        = 6 // highest verbosity
    case verbose    = 5
    case debug      = 4
    case info       = 3
    case warning    = 2
    case error      = 1
    case off        = 0
    
    /// Get string description for logger level.
    /// 
    /// - parameter logLevel: A LogLevel
    /// 
    /// - returns: A string.
    public static func description(logLevel: LogServiceLevel) -> String {
        switch logLevel {
        case .all:     return "all"
        case .verbose: return "verbose"
        case .debug:   return "debug"
        case .info:    return "info"
        case .warning: return "warning"
        case .error:   return "error"
        case .off:     return "off"
        //default: assertionFailure("Invalid level")
        //return "Null"
        }
    }
    
    // Set the "DEBUG" symbol in the compiler flags
    #if DEBUG
    static public let defaultLevel = LogServiceLevel.all
    #else
    static public let defaultLevel = LogServiceLevel.warning
    #endif
}

public func < (lhs: LogServiceLevel, rhs: LogServiceLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

public func == (lhs: LogServiceLevel, rhs: LogServiceLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

public class LogService {
    
    static var shared = LogService()
    
    /// Current log level.
    public var logLevel = LogServiceLevel.defaultLevel
    
    /// Log line counter
    private var lineCount = 0
    /// Log line numbers to watch: [Int]  
    public var watchpointList: [Int] = []
    ///
    private var logfileUrl: URL?
    
    /// DateFromatter used internally.
    private let dateFormatter = DateFormatter()
    
    public init() {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") //24H
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss.SSS"
    }
    
    // public func message
    public func verbose(_ s: String) {
        if .verbose <= logLevel {
            logWrite(s)
        }
    }
    
    public func debug(_ s: String) {
        if .debug <= logLevel {
            logWrite(s)
        }
    }
    
    public func info(_ s: String) {
        if .info <= logLevel {
            logWrite(s)
        }
    }
    
    public func warning(_ s: String) {
        if .warning <= logLevel {
            logWrite(s)
        }
    }
    
    public func error(_ s: String) {
        if .error <= logLevel {
            logWrite(s)
        }
    }
    
    private func logWrite(_ string: String) {
        lineCount += 1
        var logString = "[[\(lineCount)]] \(string)"
        #if DEBUG
        if watchpointList.contains(lineCount) {
            logString = ":::WATCHPOINT::: [[\(lineCount)]]\n" + logString
        }
        #endif
        
        if let url = logfileUrl {
            do {
                let fileHandle = try FileHandle(forWritingTo: url)
                fileHandle.seekToEndOfFile()
                if let data = (logString + "\n").data(using: .utf8) {
                    fileHandle.write( data )
                }
                fileHandle.closeFile()
            } catch {
                #if DEBUG
                print("FAIL: could not append to \(url.path)")
                    print(logString)
                #endif
            }
        } else {
            print(logString)
        }
    }
    
    public func useLogfile(url: URL?, addDatestamp: Bool = false) {
        guard let url = url else {
            logfileUrl = nil
            return 
        }
        
        let basename = url.lastPathComponent
        var logname = "\(basename).txt"
        if addDatestamp {
            let currentTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_HHmmss"
            let dateTimestamp = formatter.string(from: currentTime)

            logname = "\(basename)-\(dateTimestamp).txt"
        }

        let logdirUrl = url.deletingLastPathComponent()
        logfileUrl = logdirUrl.appendingPathComponent(logname, isDirectory: false)
        
        do {
            if let url = logfileUrl {
                try FileManager.default.createDirectory(at: logdirUrl, withIntermediateDirectories: true, attributes: nil)
                
                try "FILE: \(logname)\n".write(to: url, atomically: true, encoding: String.Encoding.utf8)
            } else {
                print(":FAIL: LogService useLogFile() logfileUrl is nil")
            }
        } catch {
            print(":FAIL: LogService useLogFile() could not write initial line to \(logname)")
        }
    }
    
}
