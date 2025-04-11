//  File: TsvRow.swift
//  AppLocalizerLib

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
        case androidKeyType
        case appleKeyType
    }
    
    init(key_android: String, key_apple: String, base_value: String = "", lang_value: String = "", base_note: String = "", lang_note: String = "") {
        self.key_android = key_android
        self.key_apple = key_apple
        self.base_value = base_value
        self.lang_value = lang_value
        self.base_note = base_note
        self.lang_note = lang_note
    }
    
    init(primaryKey: String) {
        let parts = primaryKey.components(separatedBy: ":::")
        self.key_apple = parts[0]
        self.key_android = parts[1]
        self.base_value = ""
        self.lang_value = ""
        self.base_note = ""
        self.lang_note = ""
    }
    
    func isEmpty() -> Bool {
        return key_android.isEmpty && key_apple.isEmpty && base_value.isEmpty && lang_value.isEmpty && base_note.isEmpty && lang_note.isEmpty
    }
    
    /// Primary Key
    func primaryKey() -> String {
        return "\(key_apple):::\(key_android)"
    }
    
    // a.compare(to: b) … a > b, a == b, a < b
    func compare(to toRow: TsvRow) -> String.KeyOrderRelation {
        var lhs: String = self.key_apple
        var rhs: String = toRow.key_apple
        if lhs.isEmpty {
            lhs = self.key_android
            rhs = toRow.key_android
        }
        
        let lhsParts = lhs.keyParts(lowercased: true)
        let rhsParts = rhs.keyParts(lowercased: true)
        
        if lhsParts.namePart == rhsParts.namePart {
            if let lhsInt = lhsParts.indexPart, let rhsInt = rhsParts.indexPart {
                if lhsInt < rhsInt {
                    return .lessThan
                } else if lhsInt == rhsInt {
                    return .equalTo
                } else {
                    return .greaterThan
                }
            } else {
                return .equalTo
            }
        }
        
        if lhsParts.namePart < rhsParts.namePart {
            return .lessThan
        } else if lhsParts.namePart == rhsParts.namePart {
            return .equalTo
        } else {
            return .greaterThan
        }
    }
    
    /// `keyType` determines whether `key_apple` or `key_android` has precedence
    /// returns true when `self` should be ordered before provided `TsvRow`
    func precedes(_ row: TsvRow, keyType: TsvRow.KeyType = .appleKeyType) -> Bool {
        var lhs: String!
        var rhs: String!
        
        // priority to `keyType`, fallback to other `KeyType` if empty
        if keyType == .appleKeyType { // 
            lhs = self.key_apple
            rhs = row.key_apple
            if lhs.isEmpty {
                lhs = self.key_android
                rhs = row.key_android
            }
        } else { // .androidKeyType
            lhs = self.key_android
            rhs = row.key_android
            if lhs.isEmpty {
                lhs = self.key_apple
                rhs = row.key_apple
            }
        }
        
        let lhsParts = lhs.keyParts(lowercased: true)
        let rhsParts = rhs.keyParts(lowercased: true)
        
        //returns true when lhs should be ordered before rhs
        if lhsParts.namePart == rhsParts.namePart,
           let lhsInt = lhsParts.indexPart, let rhsInt = rhsParts.indexPart {
            return lhsInt < rhsInt
        }
        return lhsParts.namePart < rhsParts.namePart
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
    
    /// Uses windows `CRLF`
    func toTsv() -> String {
        var s = "\(key_android)\t"
        s.append("\(key_apple)\t")
        s.append("\(base_value)\t")
        s.append("\(lang_value)\t")
        s.append("\(base_note)\t")
        s.append("\(lang_note)\r\n")
        return s
    }
    
    /// Uses windows `CRLF`
    static func toTsvHeader() -> String {
        return "key_droid\tkey_apple\tbase_value\tlang_value\tbase_note\tlang_note\r\n"
    }
    
}
