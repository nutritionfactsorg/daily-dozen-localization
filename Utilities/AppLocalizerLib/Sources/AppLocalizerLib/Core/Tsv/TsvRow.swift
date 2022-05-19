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
    
    enum KeyType {
        case androidKey
        case appleKey
    }
    
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
    
    func primaryKey() -> String {
        return "\(key_apple):::\(key_android)"
    }
    
    func precedes(_ row: TsvRow, key: TsvRow.KeyType) -> Bool {
        let lhs = key == .androidKey ? self.key_android : self.key_apple
        let rhs = key == .androidKey ? row.key_android : row.key_apple
        
        let lhsParts = lhs.keyParts()
        let rhsParts = rhs.keyParts()
        
        //returns true when lhs should be ordered before rhs
        if let lhsUint = lhsParts.post, let rhsUint = rhsParts.post, 
            lhsParts.base == rhsParts.base
        {
            return lhsUint < rhsUint
        }
        return lhsParts.base < rhsParts.base
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
        var s = "\(key_android)\t"
        s.append("\(key_apple)\t")
        s.append("\(base_value)\t")
        s.append("\(lang_value)\t")
        s.append("\(base_note)\t")
        s.append("\(lang_note)\r\n")
        return s
    }
    
}
