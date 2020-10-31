//
//  ShowEnvironment.swift
//  AppLocalizerLib
//
//

import Foundation

public func getCommandLineDataDirUrl() -> URL? {
    for arg in CommandLine.arguments { // ProcessInfo.processInfo.arguments
        if arg.hasPrefix("dataPath=")  {
            let path = String(arg.dropFirst("dataPath=".count))
            return URL(fileURLWithPath: path, isDirectory: true)
        }
        //else if arg.hasPrefix("argname02=")  {
        //}
    }
    return nil
}

public func getCommandLineExecDirUrl() -> URL {
    /// Note: execution directory exists in two sources:
    /// 
    /// 1. "PWD" environment variable.
    /// 2. Dir path of first CLI argument.
    URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent()
    /// Note: absolut path to …/daily-dozen-localization/Languages must be provided.
}

public func getEnvironment() -> String {
    var s = "\n###########################\n"
    s.append( "## ProcessInfo ARGUMENTS ##\n")
    for a in ProcessInfo.processInfo.arguments {
        s.append("\(a)\n")
    }
    
    s.append("\n#############################\n")
    s.append(  "## ProcessInfo ENVIRONMENT ##\n")
    for e in ProcessInfo.processInfo.environment {
        s.append("\(e.key)=\(e.value)\n")
    }

    s.append("\n##################\n")
    s.append(  "## /usr/bin/env ##\n")
    let env = Process()
    let envOut = Pipe()
    env.launchPath = "/usr/bin/env"
    env.standardOutput = envOut
    env.launch()
    env.waitUntilExit()
    s.append(String(data: envOut.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8) ?? "")    

    s.append("\n##############\n")
    s.append(  "### Bundle ###\n")
    var i = 0
    for bundle in Bundle.allBundles {
        s.append(">>> allBundles[\(i)] <<<\n")
        s.append("bundle.bundlePath=\(bundle.bundlePath)\n")
        s.append("bundle.bundleUrl.absoluteString=\(bundle.bundleURL.absoluteString)\n")
        s.append("bundle.bundleUrl.absoluteURL.path=\(bundle.bundleURL.absoluteURL.path)\n")
        s.append("bundle.bundleUrl.relativePath=\(bundle.bundleURL.relativePath)\n")
        s.append("bundle.executablePath=\(bundle.executablePath ?? "no executable path")\n")
        s.append("bundle.resourcePath=\(bundle.resourcePath ?? "no resource path")\n")
        i += 1
    }
    
    s.append("\n##################\n")
    return s
}
