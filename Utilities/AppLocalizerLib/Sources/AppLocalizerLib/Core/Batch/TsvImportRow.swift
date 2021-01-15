//
//  TsvImportRow.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvImportRow {
    /// keys
    var key_android: String = ""       
    var key_apple: String = ""
    /// values
    var base_value: String = ""
    var lang_value: String = ""
    /// comments
    var comments: String = ""
    
    func toString(includeNotes: Bool = false) -> String {
        var s = 
            """
            key_android: \(key_android)
            key_apple: \(key_apple)
            base_value: \(base_value)
            lang_value: \(lang_value)
            """
        if includeNotes {
            s.append("comments: \(comments)")
        }
        return s
    }
    
    func toStringDot(includeNotes: Bool = false) -> String {
        var s = "\(key_android)Ⓣ\(key_apple)Ⓣ\(base_value)Ⓣ\(lang_value)"
        if includeNotes {
            s.append("Ⓣ\(comments)")
        }
        return "\(key_android)Ⓣ\(key_apple)Ⓣ\(base_value)Ⓣ\(lang_value)"
    }
    
    func toTsv() -> String {
        return "\(key_android)\t\(key_apple)\t\(base_value)\t\(lang_value)\t\(comments)\r\n"
    }
    
}
