//
//  TsvRowList.swift
//  AppLocalizerLib
//

import Foundation

struct TsvRowList {
    
    var data = [TsvRow]()
    
    // MARK: - Key Management
    
    func checkKeys() -> TsvRowList {
        fatalError("not yet implemented")
    }
    
    func pairingKeys() -> TsvRowList {
        fatalError("not yet implemented")
    }
    
    // MARK: - Lookup
    
    func contains(key: String, type: TsvKeyType) -> Bool {
        for r in data {
            switch type {
            case .apple:
                if r.key_apple == key { return true }
            case .droid:
                if r.key_android == key { return true }
            }
        }
        return false
    }
    
    func contains(value: String, type: TsvValueType) -> Bool {
        for r in data {
            switch type {
            case .base:
                if r.base_value == value { return true }
            case .lang:
                if r.lang_value == value { return true }
            case .note:
                if r.note == value { return true }
            }
        }
        return false
    }
    
    func findIndices(appleKey: String) -> [Int] {
        var indices = [Int]()
        guard appleKey.isEmpty == false else { return indices }
        for i in 0 ..< data.count {
            if data[i].key_apple == appleKey {
                indices.append(i)
            }
        }
        return indices
    }
    
    func findIndices(comboKey: String) -> [Int] {
        let keys = comboKey.components(separatedBy: ":")
        guard keys.count == 2 else {
            fatalError("comboKey must have two parts")
        }
        var found = [Int]()
        for i in 0 ..< data.count {
            if data[i].key_apple == keys[0] && data[i].key_android == keys[1] {
                found.append(i)
            }
        }
        return found
    }
    
    func findIndices(droidKey: String) -> [Int] {
        var indices = [Int]()
        guard droidKey.isEmpty == false else { return indices }
        for i in 0 ..< data.count {
            if data[i].key_android == droidKey {
                indices.append(i)
            }
        }
        return indices
    }
    
    func findIndices(baseValue: String) -> [Int] {
        var indices = [Int]()
        for i in 0 ..< data.count {
            if data[i].base_value == baseValue {
                indices.append(i)
            }
        }
        return indices
    }
    
    // MARK: - Operations: single row
    
    mutating func append(_ row: TsvRow) {
        self.data.append(row)
    }
    
    func get(key: String, keyType: TsvKeyType) -> TsvRow? {
        // Prerequisite: key pairing completed. multi-key cases have uniform values.
        // When prerequisites are met, then the first instance is defining
        for row in data {
            switch keyType {
            case .apple:
                if row.key_apple == key { return row }
            case .droid:
                if row.key_android == key { return row }
            }
        }
        return nil
    }
    
    mutating func putValue(key: String, keyType: TsvKeyType, value: String, valueType: TsvValueType, mode: TsvPutMode = .verbatim) {
        // Prerequisite: key pairing completed. all keys are in place.
        // An Android key may map to multiple Apples, so check all rows.
        var keyNotFound = true
        for i in 0 ..< data.count {
            var d = data[i]
            switch keyType {
            case .apple:
                if d.key_apple != key { continue } 
            case .droid:
                if d.key_android != key { continue } 
            }
            keyNotFound = false
            switch mode {
            case .doNotOverwrite:
                switch valueType {
                case .base:
                    d.base_value =  d.base_value.isEmpty ? value : d.base_value
                case .lang:
                    d.lang_value = d.lang_value.isEmpty ? value : d.lang_value
                case .note:
                    d.note = d.note.isEmpty ? value : d.note
                }
            case .verbatim:
                switch valueType {
                case .base:
                    d.base_value = value
                case .lang:
                    d.lang_value = value
                case .note:
                    d.note = value
                }
            }
            data[i] = d // writeback
        }
        // Create if not present to update
        if keyNotFound {
            let newRow = TsvRow(
                key_android: keyType == .droid ? key : "", 
                key_apple: keyType == .apple ? key : "", 
                base_value: valueType == .base ? value : "", 
                lang_value:  valueType == .lang ? value : "", 
                note:  valueType == .note ? value : ""
            )
            data.append(newRow)
        }
    }
    
    /// Replaces values of `base_value`, `lang_value` and  `note` 
    mutating func putRowValues(key: String, keyType: TsvKeyType, row: TsvRow, mode: TsvPutMode = .verbatim) {
        // Prerequisite: key pairing completed. all keys are in place.
        // An Android key may map to multiple Apples, so check all rows.
        var keyNotFound = true
        // Update
        for i in 0 ..< data.count {
            var d = data[i]
            switch keyType {
            case .apple:
                if d.key_apple != key { continue } 
            case .droid:
                if d.key_android != key { continue } 
            }
            keyNotFound = false
            switch mode {
            case .doNotOverwrite:
                d.base_value = d.base_value.isEmpty ? row.base_value : d.base_value
                d.lang_value = d.lang_value.isEmpty ? row.lang_value : d.lang_value
                d.note = d.note.isEmpty ? row.note : d.note
            case .verbatim:
                d.base_value = row.base_value
                d.lang_value = row.lang_value
                d.note = row.note                
            }
            data[i] = d // writeback
        }
        // Create if not present to update
        if keyNotFound {
            let newRow = TsvRow(
                key_android: keyType == .droid ? key : "", 
                key_apple: keyType == .apple ? key : "", 
                base_value: row.base_value, 
                lang_value: row.lang_value, 
                note: row.note
            )
            data.append(newRow)
        }
    }
    
    /// Removes all instances with matching key
    mutating func remove(key: String, keyType: TsvKeyType) {
        // Prerequisite: key pairing completed. multi-key cases have uniform values.
        // When prerequisites are met, then the first instance is defining
        data = data.filter { (row: TsvRow) -> Bool in
            switch keyType {
            case .apple:
                return row.key_apple != key
            case .droid:
                return row.key_android != key
            }            
        }
    }
    
    // MARK: - Operations: many rows
    
    mutating func append(contentsOf list: TsvRowList) {
        for r in list.data {
            self.data.append(r)
        }
    }

    func applyingValues(from: TsvRowList, withKeyType: TsvKeyType, ofValueTypeList: [TsvValueType]) -> TsvRowList {
        var result = from
        for valueType in ofValueTypeList {
            result = applyingValues(from: result, withKeyType: withKeyType, ofValueType: valueType)
        }
        return result
    }

    func applyingValues(from: TsvRowList, withKeyValueTypes: [(keyType: TsvKeyType, valueType: TsvValueType)]) -> TsvRowList {
        var result: TsvRowList! 
        for t in withKeyValueTypes {
            result = applyingValues(from: result, withKeyType: t.keyType, ofValueType: t.valueType)
        }
        return result
    }

    func applyingValues(from: TsvRowList, withKeyType: TsvKeyType, ofValueType: TsvValueType, putMode: TsvPutMode = .verbatim) -> TsvRowList {
        var result = TsvRowList(data: self.data)
        for d in from.data {
            var key: String!
            var value: String!
            switch withKeyType {
            case .apple:
                key = d.key_apple
            case .droid:
                key = d.key_android
            }
            switch ofValueType {
            case .base:
                value = d.base_value
            case .lang:
                value = d.lang_value
            case .note:
                value = d.note
            }
            result.putValue(key: key, keyType: withKeyType, value: value, valueType: ofValueType)
        }
                
        return result
    }
    
    func diffKeys(_ other: TsvRowList, byKeyType: TsvKeyType) -> (added: TsvRowList, dropped: TsvRowList) {
        let added = subtracting(other, byKeyType: byKeyType)
        let dropped = other.subtracting(self, byKeyType: byKeyType)                
        return (added, dropped)
    }

//    func diffContent(_ other: TsvRowList, byKeyType: TsvKeyType) -> (added: TsvRowList, dropped: TsvRowList) {
//        let added = subtracting(other, byKeyType: byKeyType)
//        let dropped = other.subtracting(self, byKeyType: byKeyType)
//        var modified = TsvRowList()
//                
//        return (added, dropped)
//    }

    func sorted() -> TsvRowList {
        var list = data
        list.sort { (a: TsvRow, b: TsvRow) -> Bool in
            // Return true to order first element before the second.
            if !a.key_apple.isEmpty && !b.key_apple.isEmpty {
                if !a.key_apple.isRandomKey && !b.key_apple.isRandomKey {
                    return a.key_apple < b.key_apple
                } else if !a.key_apple.isRandomKey {
                    return true
                } else if !b.key_apple.isRandomKey {
                    return false
                } else {
                    if !a.key_android.isEmpty && !b.key_android.isEmpty {
                        return a.key_android < b.key_android
                    } else if !a.key_android.isEmpty {
                        return true
                    } else if !b.key_android.isEmpty {
                        return false
                    }
                }
                // case: two random apple keys. no android keys.
                return a.base_value < b.base_value
                // return a.key_apple < b.key_apple
            } else if !a.key_apple.isEmpty && !a.key_apple.isRandomKey {
                return true
            } else if !b.key_apple.isEmpty && !b.key_apple.isRandomKey {
                return false
            }
            if !a.key_android.isEmpty && !b.key_android.isEmpty {
                return a.key_android < b.key_android                
            } else if !a.key_android.isEmpty {
                return true
            }
            return false
        }
        return TsvRowList(data: list)
    }
        
    func subtracting(_ toRemove: TsvRowList, byKeyType: TsvKeyType) -> TsvRowList {
        // Prerequisite: key pairing completed. multi-key cases have uniform values.
        // When prerequisites are met, then the first instance is defining
        let result = self.data.filter { (r: TsvRow) -> Bool in
            // return true if the row is to be kept
            switch byKeyType {
            case .apple:
                return toRemove.contains(key: r.key_apple, type: .apple) == false
            case .droid:
                return toRemove.contains(key: r.key_android, type: .droid) == false
            }            
        }
        return TsvRowList(data: result)
    }

    // MARK: - Output

    func toStringDot(rowIdx: Int) -> String {
        return data[rowIdx].toStringDot()
    }
    
    func toTsv(rowIdx: Int) -> String {
        return data[rowIdx].toTsv()
    }
    
    func toTsv() -> String {
        var s = "key_droid\tkey_apple\tbase_value\tlang_value\tbase_note\r\n"
        for tsvRow in self.sorted().data {
            s.append(tsvRow.toTsv())
        }
        return s
    } 
    
    func writeTsvFile(_ url: URL) {
        let outputString = self.toTsv()
        do {
            try outputString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(":ERROR: TsvRowList writeTsvFile \(error)")
        }
    }
    
}
