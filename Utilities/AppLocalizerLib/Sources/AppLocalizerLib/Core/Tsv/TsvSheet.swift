//
//  TsvSheet.swift
//  AppLocalizerLib
//

import Foundation

struct TsvSheet: TsvProtocol {
    
    var tsvRowList = TsvRowList()
    var logger = LogService()
    var urlLanguage: URL
    
    enum platform {
        case android
        case apple
    }
    
    init(urlList: [URL], loglevel: LogServiceLevel = .info) {
        logger.logLevel = loglevel
        guard let url = urlList.first  else {
            fatalError("At least 1 TSV import file is required.")
        }
        urlLanguage = url
            .deletingLastPathComponent() // "filename.ext"
            .deletingLastPathComponent() // "tsv/"
        for url in urlList {
            var tmpTsvRowList = parseTsvFile(url: url)
            tmpTsvRowList = normalizeAndroidKeys(tsvRowList: tmpTsvRowList)
            tmpTsvRowList = normalizeAppleKeys(tsvRowList: tmpTsvRowList)
            tmpTsvRowList = tmpTsvRowList.sorted()
            tsvRowList.append(contentsOf: tmpTsvRowList)
            writeTsvFile(tmpTsvRowList, baseTsvFileUrl: url)
        }
        tsvRowList = tsvRowList.sorted()
    }
    
    /// Check for TSV keys not used
    func checkTsvKeysNotused(platformKeysUsed: Set<String>, platform: TsvSheet.platform) -> Set<String> {
        var tsvKeySet = Set<String>()
        for r in tsvRowList.data {
            switch platform {
            case .android:
                if r.key_android.isEmpty == false {
                    tsvKeySet.insert(r.key_android)
                }
            case .apple:
                if r.key_apple.isEmpty == false {
                    tsvKeySet.insert(r.key_apple)
                }
            }
        }
        return tsvKeySet.subtracting(platformKeysUsed)
    }
    
    /// Check of multiple instances of the same key.
    /// If duplicate keys are present, then values are checks to be the same. 
    func checkTsvKeysDuplicated(platform: TsvSheet.platform) -> Set<String> {
        var tsvAllKeys = Set<String>()
        var tsvDuplicateKeys = Set<String>()
        for r in tsvRowList.data {
            let key = platform == .android ? r.key_android : r.key_apple
            if tsvAllKeys.contains(key) {
                tsvDuplicateKeys.insert(key)
            } else {
                tsvAllKeys.insert(key)
            }
        }
        // :NYI: verify values are consistant across any duplicate keys
        return tsvDuplicateKeys
    }

    /// Checks for cases where the base language and target language have the same value
    func checkTsvKeysTargetValueSameAsBase() -> [TsvRow] {
        var unchanged = [TsvRow]()
        for r in tsvRowList.data {
            if (r.key_android.isEmpty == false || r.key_apple.isEmpty == false) &&
                r.base_value.isEmpty == false && 
                r.base_value == r.lang_value {
                unchanged.append(r)
            }
        }
        return unchanged
    }
    
    /// Checks for cases where the base language is present and a translation is not present.
    func checkTsvKeysTargetValueMissing() -> [TsvRow] {
        var missing = [TsvRow]()
        for r in tsvRowList.data {
            if r.key_android.isEmpty == false || r.key_apple.isEmpty == false {
                if r.lang_value.isEmpty {
                    missing.append(r)
                }
            }
        }
        return missing
    }

    func getKeySetAndroid() -> Set<String> {
        return Set<String>(getLookupDictAndroid().keys)
    }

    func getKeySetApple() -> Set<String> {
        return Set<String>(getLookupDictApple().keys)
    }
    
    func getLookupDictAndroid() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            d[r.key_android] = r.lang_value
        }
        return d
    }
    
    func getLookupDictApple() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            d[r.key_apple] = r.lang_value
        }
        return d
    }
    
    func getDictionaries() -> (apple: [String : TsvRow], droid: [String : TsvRow], paired: [String : TsvRow]) {
        var apple = [String : TsvRow]()
        var droid = [String : TsvRow]()
        var paired = [String : TsvRow]()
        
        for row in tsvRowList.data {
            apple[row.key_apple] = row
            droid[row.key_android] = row
            paired[row.key_apple+row.key_android] = row
        } 
        return (apple, droid, paired)
    }
    
    // MARK: - Normalize Keys

    mutating func normalizeAndroidKeys(tsvRowList: TsvRowList) -> TsvRowList {
        var newTsvRowList = TsvRowList()
        for i in 0 ..< tsvRowList.data.count {
            var r = tsvRowList.data[i]
            
            // Check for keys which have an added Apple-Android crossmapping
            // Crossmaping may add a correlated key to an otherwise empty Android key 
            if let newKey = TsvRemapDroid.check.isCrossmapUpdated(r) {
                r.key_android = newKey
                newTsvRowList.append(r)
                continue
            }

            // 
            if r.key_android.isEmpty {
                newTsvRowList.append(r)
                continue
            }
            
            // Check for keys to be dropped
            if TsvRemapDroid.check.isDropped(r.key_android) == true {
                continue
            }
            
            // Check for keys to be replaced
            if let newKey = TsvRemapDroid.check.isReplaced(r.key_android) {
                r.key_apple = newKey
                newTsvRowList.append(r)
                continue
            }
                        
            // Check for keys which have a patch fix 
            if let newKey = TsvRemapDroid.check.isPatched(r) {
                r.key_android = newKey
                newTsvRowList.append(r)
                continue
            }

            //print(":WATCH:NormalizeAndroid: \(r.key_android)")
            
            // 
            r.key_android = r.key_android.replacingOccurrences(of: "[heading]", with: "", options: .literal)
            r.key_android = r.key_android.replacingOccurrences(of: "[short]", with: "_short", options: .literal)
            r.key_android = r.key_android.replacingOccurrences(of: "[text]", with: "_text", options: .literal)
            // *[imperial][n], *[metric][n]
            r.key_android = r.key_android.replacingOccurrences(of: "\\[(.*)\\]\\[(.*)\\]", with: "_$1.$2", options: .regularExpression)
            r.key_android = r.key_android.replacingOccurrences(of: "\\[(.*)\\]", with: ".$1", options: .regularExpression)
            newTsvRowList.append(r)
        }
        return newTsvRowList
    }

    mutating func normalizeAppleKeys(tsvRowList: TsvRowList) -> TsvRowList {
        var newTsvRowList = TsvRowList()
        for i in 0 ..< tsvRowList.data.count {
            var r = tsvRowList.data[i]
            if r.key_apple.isEmpty {
                newTsvRowList.append(r)
                continue
            }
            
            //let watch = r.key_apple.contains("segmentTitles")
            //if watch {
            //    print(":WATCH:BEFORE: \(r.key_apple)")
            //}
            
            // Check for keys to be dropped
            if TsvRemapApple.check.isDropped(r.key_apple) == true {
                continue
            }
            
            // Check for keys to be replaced
            if let newKey = TsvRemapApple.check.isReplaced(r.key_apple) {
                r.key_apple = newKey
                newTsvRowList.append(r)
                continue
            }

            // Regex List
            // [a][b] -> .a.b
            r.key_apple = r.key_apple.replacingOccurrences(of: "\\[(.*)\\]\\[(.*)\\]", with: ".$1.$2", options: .regularExpression)
            // [a] -> .a
            r.key_apple = r.key_apple.replacingOccurrences(of: "\\[(.*)\\]", with: ".$1", options: .regularExpression)
            // "Serving." -> ".Serving."
            r.key_apple = r.key_apple.replacingOccurrences( of: "Serving.", with: ".Serving.", options: .literal)
            r.key_apple = r.key_apple.replacingOccurrences( of: "..", with: ".", options: .literal)
            // "VarietyText." -> ".Variety.Text."
            r.key_apple = r.key_apple.replacingOccurrences(of: "VarietyText.", with: ".Variety.Text.", options: .literal)
            // "segmentTitles.0" -> "segmentTitles[0]"
            r.key_apple = r.key_apple.replacingOccurrences(of: "segmentTitles.(.)", with: "segmentTitles[$1]", options: .regularExpression)
            // :!!!:NYI: Tweak Activity
            
            
            //if watch {
            //    print(":WATCH:AFTER: \(r.key_apple)")
            //}
            
            newTsvRowList.append(r)
        }
        return newTsvRowList
    }

    // MARK: - Operations
    
    // no TsvProtocol overrides
        
    // MARK: - Output

    /// Allows invisible characters to be seen
    func toCharacterDot(character: Character?) -> Character {
        switch character {
        case "\n":
           return "Ⓝ"
        case "\r":
            return "Ⓡ"
        case "\r\n":
            return "Ⓧ"
        case "\t":
            return "Ⓣ"
        default:
            return character ?? "␀"
        }
    }

    func toString() -> String {
        var s = ""
        var index = 0
        for r in tsvRowList.data {
            s.append("record[\(index)]:\n\(r.toString())\n")
            index += 1
        }
        return s
    }
    
    func toStringDot() -> String {
        var s = ""
        for r in tsvRowList.data {
            s.append("Ⓝ\(r.toStringDot())\n")
        }
        return s
    } 
    
    /// Allows invisible characters to be seen on one line
    func toStringDot(field: [Character]) -> String {
        var s = ""
        for c in field {
            s.append(toCharacterDot(character: c))
        }
        return s
    }

    // Add datestamp to `baseTsvFileUrl`
    private func writeTsvFile(_ list: TsvRowList, baseTsvFileUrl: URL) {
        let outputUrl = baseTsvFileUrl
            .deletingPathExtension()
            .appendingPathExtension("\(Date.datestampyyyyMMddHHmm).tsv")
        list.writeTsvFile(outputUrl)
    }

    func writeTsvFile(fullUrl: URL) {
        tsvRowList.writeTsvFile(fullUrl)
    }
    
    // MARK:- Parse
    
    mutating func parseTsvFile(url: URL) -> TsvRowList {
        var recordList = [TsvRow]()
        let newline: Set<Character> = ["\n", "\r", "\r\n"]
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            // .split(whereSeparator: (Character) throws -> Bool)
            // Value of type 'String.Element' (aka 'Character') has no member 'isNewLine'
            
            if content.count < 100 {
                print(":ERROR: TsvSheet did not init with \(url.absoluteString)")
                return TsvRowList(data: recordList)
            }
            
            var cPrev: Character? // Previous UTF-8 Character
            var cThis: Character? // Current UTF-8 Character
            var cNext: Character? // Next UTF-8 Character
                    
            var insideQuote = false
            var escapeQuote = false
            var record: [String] = []
            var field: [Character] = []
            var countChar = 0
            var lineIdx = 1
            var lineCharIdx = 0
            
            for character in content {
                if _watchEnabled {
                    _watchline(recordIdx: recordList.count, recordFieldIdx: record.count, lineIdx: lineIdx, lineCharIdx: lineCharIdx, field: field, insideQuote: insideQuote, escapeQuote: escapeQuote, cPrev: cPrev, cThis: cThis, cNext: cNext)
                }
                cPrev = cThis
                cThis = cNext
                cNext = character
                countChar += 1
                lineCharIdx += 1
                if let cThis = cThis, newline.contains(cThis) {
                    if insideQuote {
                        field.append("\n")
                    } else {
                        let fieldStr = String(field).trimmingCharacters(in: .whitespaces)
                        record.append(fieldStr) // Add last field to record
                        if record.count >= 5 {
                            // Requires either an Android key or an Apple key
                            if !record[0].isEmpty || !record[1].isEmpty {
                                // Add non-empty record to list.
                                let r = TsvRow(
                                    key_android: record[0], 
                                    key_apple: record[1], 
                                    base_value: record[2], 
                                    lang_value: record[3],
                                    base_note: record[4]
                                )
                                if r.key_android != "key_droid" { // skip headings record
                                    recordList.append(r)                                    
                                }
                            }
                            lineIdx += 1
                            lineCharIdx = 0
                        }
                        field = []
                        record = []
                        escapeQuote = false
                        insideQuote = false
                    }
                } else if cThis == "\t" {
                    if insideQuote {
                        field.append("\t")
                    } else {
                        let fieldStr = String(field).trimmingCharacters(in: .whitespaces)
                        record.append(fieldStr) // Add field to list.
                        field = []
                        escapeQuote = false
                        insideQuote = false
                    }
                } else if cThis == "\"" {
                    if insideQuote {
                        if escapeQuote {
                            if cPrev == "\"" {
                                field.append("\"")
                                escapeQuote = false                                
                            } else {
                                fatalError(":ERROR:@line\(lineIdx)[\(lineCharIdx)]: TsvSheet escaped quote must precede ::\(toStringDot(field:field))::")
                            }
                        } else {
                            if let cNext = cNext, newline.contains(cNext) || cNext == "\t" {
                                insideQuote = false
                            } else {
                                escapeQuote = true
                            }
                        }
                    } else {
                        if cPrev == nil {
                            insideQuote = true
                            escapeQuote = false
                        } else if let cPrev = cPrev, newline.contains(cPrev) || cPrev == "\t" {
                                insideQuote = true
                                escapeQuote = false
                        } else {
                            // print(":CHECK:@\(position): TsvSheet double quote in \(field)")
                            if let cThis = cThis {
                                field.append(cThis)
                            }
                        }
                    }
                } else {
                    if let cThis = cThis {
                        field.append(cThis)
                    }
                }
            }
            
            // Handle last Character
            if let cNext = cNext, !newline.contains(cNext) && cNext != "\t" {
                field.append(cNext) // Add last character
            }
            let fieldStr = String(field).trimmingCharacters(in: .whitespaces)
            if fieldStr.isEmpty == false {
                record.append(fieldStr) // Add last field
            }
            // Requires either an Android key or an Apple key
            if !record[0].isEmpty || !record[1].isEmpty {
                let r = TsvRow(
                    key_android: record[0], 
                    key_apple: record[1], 
                    base_value: record[2], 
                    lang_value: record[3],
                    base_note: record.count > 4 ? record[4] : ""
                )
                recordList.append(r) // Add last record
            }
            
        } catch {
            print(  "TsvSheet error:\n\(error)")
        }
        return TsvRowList(data: recordList)
    }
    
    static func sortRecordList(_ tsvRowList: TsvRowList) -> TsvRowList {
        var list = tsvRowList.data
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

    // MARK: - Watch
    
    // :WATCH: setup
    fileprivate var _watchCharCount = 0
    fileprivate let _watchCharLimit = 2000 // number of characters to check
    fileprivate var _watchEnabled = false
    fileprivate let _watchString = "k" 
    
    fileprivate mutating func _watchline(
        recordIdx: Int,
        recordFieldIdx: Int,
        lineIdx: Int,
        lineCharIdx: Int,
        field: [Character],
        insideQuote: Bool,
        escapeQuote: Bool,
        cPrev: Character?,
        cThis: Character?,
        cNext: Character?
    ) {
        if String(field) == _watchString && _watchCharCount == 0 {
            print(":WATCH:START: \"\(_watchString)\"")
            print(":WATCH:\trecordIdx\tlineIdx\tlineCharIdx\tinsideQuote\tescapeQuote\tcPrev\tcThis\tcNext")
            _watchCharCount = 1
        }
        
        if _watchCharCount > 0 && _watchCharCount <= _watchCharLimit {
            var s = ":WATCH:"
            s.append("\t\(recordIdx)[\(recordFieldIdx)]")
            s.append("\t\(lineIdx)")
            s.append("\t\(lineCharIdx)")
            s.append("\t\(insideQuote)")
            s.append("\t\(escapeQuote)")
            s.append("\t\(toCharacterDot(character: cPrev))")
            s.append("\t\(toCharacterDot(character: cThis))")
            s.append("\t\(toCharacterDot(character: cNext))")
            s.append("\t\(toStringDot(field:field))")
            print(s)
            _watchCharCount += 1
        } else if _watchCharCount > _watchCharLimit {
            _watchEnabled = false
        }
    }

}
