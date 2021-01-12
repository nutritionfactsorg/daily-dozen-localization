//
//  TsvImportRow.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvImportRow {
    /// "key"
    var key_android: String = ""       
    var key_apple: String = ""
    /// values
    var base_value: String = ""
    var lang_value: String = ""
    
    func toString() -> String {
        return
            """
            key_android: \(key_android)
            key_apple: \(key_apple)
            base_value: \(base_value)
            lang_value: \(lang_value)
            """
    }
    
    func toStringDot() -> String {
        return "\(key_android)Ⓣ\(key_apple)Ⓣ\(base_value)Ⓣ\(lang_value)"
    }
    
    func toTsv() -> String {
        return "\(key_android)\t\(key_apple)\t\(base_value)\t\(lang_value)\r\n"
    }
    
}
