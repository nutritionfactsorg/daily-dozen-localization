//
//  StdioExtensions.swift
//  UrlCheckLib
//

import Foundation

// **Notes**
//
// * StdioExtensions.swift provides three approaches for adding stderr access.
// * StdioExtensions.swift is not needed if only stdout output will be used.

extension FileHandle : TextOutputStream {
    public func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.write(data)
    }
}

////////////////////////////
// Approach: add function //
////////////////////////////
// Adds printError() for stderr.
// Use  existing print() for stdout.

/// Writes to `stderr`.
func printError(_ string: String) {
    let stderr = FileHandle.standardError
    
    guard let data = string.data(using: .utf8) else {
        return // encoding failure
    }
    // write to stderr file handle
    stderr.write(data)
}

/////////////////////////////////////////////////////
// Approach: global standardError & standardOutput //
/////////////////////////////////////////////////////
// Adds `standardError` for
// Adds `standardOutput` so that stdout can be access in same approach as standardError

/// System stderr output text stream.
var standardError = FileHandle.standardError
/// System stdout output text stream.
var standardOutput = FileHandle.standardOutput

////////////////////////////////////
// Approach: add stdio structures //
////////////////////////////////////

struct StandardErrorStream: TextOutputStream {
    private let stderrStream = FileHandle.standardError
    
    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return // encoding failure
        }
        stderrStream.write(data)
    }
}

struct StandardOutputStream: TextOutputStream {
    private let stdoutStream = FileHandle.standardOutput
    
    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            return // encoding failure
        }
        stdoutStream.write(data)
    }
}
