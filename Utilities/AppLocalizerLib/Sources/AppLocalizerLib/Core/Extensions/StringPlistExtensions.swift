//
//  StringPlistExtensions.swift
//  AppLocalizerLib
//

import Foundation

public extension String {
    
    mutating func plistAddArray(key: String, dictList: [String]) {
        var s = ""
        for item in dictList {
            s = s + "\(item)\n"
        }
        self = self + "<key>\(key)</key>\n<array>\n" + s + "</array>"
    }
    
    mutating func plistAddArray(key: String, stringList: [String]) {
        var s = ""
        for item in stringList {
            s = s + "<string>\(item)</array>\n"
        }
        self = self + "<key>\(key)</key>\n<array>\n" + s + "</array>"
    }
    
    /// <dict><key>…</key><string>…</string></dict>
    mutating func plistAddDict(key: String, string: String?) {
        let s = """
        <dict>\
            <key>\(key)</key>\
            <string>\(string ?? "")</string>\
        </dict>
        """
        self = self + s
    }
    
    mutating func plistAddString(key: String, string: String?) {
        let s = """
        <key>\(key)</key>\
        <string>\(string ?? "")</string>
        """
        self = self + s
    }
    
    /// <plist>…</plist>
    mutating func plistWrapDoc() {
        let tagBegin = """
        <?xml version="1.0" encoding="UTF-8"?>\
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\
        <plist version="1.0">\
        <dict>
        """
        let tagClose = """
        </dict>\
        </plist>
        """
        self = tagBegin + self + tagClose
    }
    
}
