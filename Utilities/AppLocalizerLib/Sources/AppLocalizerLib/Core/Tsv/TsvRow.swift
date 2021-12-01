//
//  TsvRow.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvRow: Equatable {
    /// keys
    var key_android: String       
    var key_apple: String
    /// values
    var base_value: String
    var lang_value: String
    /// comments
    var base_note: String // general information to assist translation
    var lang_note: String // :NYI: ... applies to website URLs.
    
    init(key_android: String, key_apple: String, base_value: String, lang_value: String, base_note: String, lang_note: String) {
        self.key_android = key_android       
        self.key_apple = key_apple
        self.base_value = base_value
        self.lang_value = lang_value
        self.base_note = base_note
        self.lang_note = lang_note
    }
    
    func isEmpty() -> Bool {
        return key_android.isEmpty && key_apple.isEmpty && base_value.isEmpty && lang_value.isEmpty && base_note.isEmpty && lang_note.isEmpty
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
            s.append("base_note: \(base_note)\n")
            s.append("lang_note: \(lang_note)")
        }
        return s
    }
    
    func toStringDot(includeNotes: Bool = false) -> String {
        var s = "\(key_android)Ⓣ\(key_apple)Ⓣ\(base_value)Ⓣ\(lang_value)"
        if includeNotes {
            s.append("Ⓣ\(base_note)")
            s.append("Ⓣ\(lang_note)")
        }
        return s
    }
    
    func toTsv() -> String {
        var s = "\(toTsvQuoted(key_android))\t"
        s.append("\(toTsvQuoted(key_apple))\t")
        s.append("\(toTsvQuoted(base_value))\t")
        s.append("\(toTsvQuoted(lang_value))\t")
        s.append("\(toTsvQuoted(base_note))\t")
        s.append("\(toTsvQuoted(lang_note))\r\n")
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
