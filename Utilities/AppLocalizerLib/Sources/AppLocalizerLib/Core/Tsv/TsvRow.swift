//
//  TsvRow.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvRow {
    /// keys
    var key_android: String       
    var key_apple: String
    /// values
    var base_value: String
    var lang_value: String
    /// comments
    var note: String
    
    init(key_android: String, key_apple: String, base_value: String, lang_value: String, note: String) {
        self.key_android = key_android       
        self.key_apple = key_apple
        self.base_value = base_value
        self.lang_value = lang_value
        self.note = note
    }
    
    func toString(includeNotes: Bool = false) -> String {
        var s = 
            """
            key_android: \(key_android)
            key_apple: \(key_apple)
            base_value: \(base_value)
            lang_value: \(lang_value)
            """
        if includeNotes {
            s.append("note: \(note)")
        }
        return s
    }
    
    func toStringDot(includeNotes: Bool = false) -> String {
        var s = "\(key_android)Ⓣ\(key_apple)Ⓣ\(base_value)Ⓣ\(lang_value)"
        if includeNotes {
            s.append("Ⓣ\(note)")
        }
        return "\(key_android)Ⓣ\(key_apple)Ⓣ\(base_value)Ⓣ\(lang_value)"
    }
    
    func toTsv() -> String {
        var s = "\(toTsvQuoted(key_android))\t"
        s.append("\(toTsvQuoted(key_apple))\t")
        s.append("\(toTsvQuoted(base_value))\t")
        s.append("\(toTsvQuoted(lang_value))\t")
        s.append("\(toTsvQuoted(note))\r\n")
        return s
    }
    
    private func toTsvQuoted(_ s: String) -> String {
        var string = s
        if string.hasPrefix("\"") {
            string = string.replacingOccurrences(of: "\"", with: "\"\"")
            return "\"\(string)\""
        } 
        return string
    }
    
}
