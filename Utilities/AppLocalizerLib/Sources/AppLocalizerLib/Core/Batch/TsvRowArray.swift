//
//  TsvRowArray.swift
//  AppLocalizerLib
//

import Foundation

struct TsvRowArray {
    
    enum KeyType {
        case Apple
        case Combo // "Apple:Droid"
        case Droid
    }
    
    enum ValueType {
        case base // English
        case lang // target language
        case note
    }
    
    var data = [TsvRow]()
    
    // MARK: - Lookup
    
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

    // MARK: - Modify One
    
    func put(value: String, withKeyType: KeyType, ofValueType: ValueType) {
        
        
    }
    
    // MARK: - Modify Many
    
    func applyingValues(from: TsvRowArray, withKeyType: KeyType, ofValueType: [ValueType]) -> TsvRowArray {
        
    }
    
    func merging(from: TsvRowArray, ofValueType: ValueType, withKeyType: KeyType) -> TsvRowArray {
        for <#item#> in <#items#> {
            <#code#>
        }
    }
    
    func pairingKeys() -> TsvRowArray {
        
    }
    
     func sorted() -> [TsvRow] {
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
        return list
    }
    
    func subtracting(_ toRemove: TsvRowArray, byKeyType: KeyType) -> TsvRowArray {
        
    }
    
    
    
}
