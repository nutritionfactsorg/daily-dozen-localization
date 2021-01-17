//
//  TsvImportSheet.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvImportSheet {
    var recordListAll: [TsvImportRow] = []
    var logger = LogService()
        
    enum platform {
        case android
        case apple
    }
    
    init(urlList: [URL], loglevel: LogServiceLevel = .info) {
        logger.logLevel = loglevel
        for url in urlList {
            var recordList = parseTsvFile(url: url)
            recordList = parseTsvFile(url: url)
            recordList = parseUpdateAndroidKeys(recordList: recordList)
            recordList = parseUpdateAppleKeys(recordList: recordList)
            saveTsvFile(url: url, recordList: recordList)
        }
    }
    
    /// Check for TSV keys not used
    func checkTsvKeysNotused(platformKeysUsed: Set<String>, platform: TsvImportSheet.platform) -> Set<String> {
        var tsvKeySet = Set<String>()
        for r in recordListAll {
            switch platform {
            case .android:
                tsvKeySet.insert(r.key_android)
            case .apple:
                tsvKeySet.insert(r.key_apple)
            }
        }
        return tsvKeySet.subtracting(platformKeysUsed)
    }
    
    /// Check of multiple instances of the same key.
    /// If duplicate keys are present, then values are checks to be the same. 
    func checkTsvKeysDuplicated(platform: TsvImportSheet.platform) -> Set<String> {
        var tsvAllKeys = Set<String>()
        var tsvDuplicateKeys = Set<String>()
        for r in recordListAll {
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
    func checkTsvKeysTargetValueSameAsBase() -> [TsvImportRow] {
        var unchanged = [TsvImportRow]()
        for r in recordListAll {
            if !r.key_android.isEmpty || !r.key_apple.isEmpty {
                if r.base_value == r.lang_value {
                    unchanged.append(r)
                }
            }
        }
        return unchanged
    }
    
    func checkTsvKeysTargetValueMissing() -> [TsvImportRow] {
        var missing = [TsvImportRow]()
        for r in recordListAll {
            if !r.key_android.isEmpty || !r.key_apple.isEmpty {
                if r.lang_value.isEmpty {
                    missing.append(r)
                }
            }
        }
        return missing
    }
        
    func getLookupDictAndroid() -> [String: String] {
        var d = [String: String]()
        for r in recordListAll {
            d[r.key_android] = r.lang_value
        }
        return d
    }
    
    func getLookupDictApple() -> [String: String] {
        var d = [String: String]()
        for r in recordListAll {
            d[r.key_apple] = r.lang_value
        }
        return d
    }
    
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
        for r in recordListAll {
            s.append("record[\(index)]:\n\(r.toString())\n")
            index += 1
        }
        return s
    }
    
    func toStringDot() -> String {
        var s = ""
        for r in recordListAll {
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

    func toTsv(recordList: [TsvImportRow]) -> String {
        var s = ""
        for tsvImportRow in recordList {
            s.append(tsvImportRow.toTsv())
        }
        return s
    } 
    
    // MARK:- Parsing
    
    mutating func parseTsvFile(url: URL) -> [TsvImportRow] {
        var recordList = [TsvImportRow]()
        let newline: Set<Character> = ["\n", "\r", "\r\n"]
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            // .split(whereSeparator: (Character) throws -> Bool)
            // Value of type 'String.Element' (aka 'Character') has no member 'isNewLine'
            
            if content.count < 100 {
                print(":ERROR: TsvImportSheet did not init with \(url.absoluteString)")
                return recordList
            }
            
            var cPrev: Character? // Previous UTF-8 Character
            var cThis: Character? // Current UTF-8 Character
            var cNext: Character? // Next UTF-8 Character
                    
            var insideQuote = false
            var escapeQuote = false
            var record: [[Character]] = []
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
                        record.append(field) // Add last field to record. 
                        if record.count >= 5 {
                            if !record[0].isEmpty || !record[1].isEmpty || !record[2].isEmpty || !record[3].isEmpty {
                                // Add non-empty record to list.
                                let r = TsvImportRow(
                                    key_android: String(record[0]), 
                                    key_apple: String(record[1]), 
                                    base_value: String(record[2]), 
                                    lang_value: String(record[3]),
                                    comments: String(record[4])
                                )
                                recordList.append(r)
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
                        record.append(field) // Add field to list.
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
                                fatalError(":ERROR:@line\(lineIdx)[\(lineCharIdx)]: TsvImportSheet escaped quote must precede ::\(toStringDot(field:field))::")
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
                            // print(":CHECK:@\(position): TsvImportSheet double quote in \(field)")
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
            if field.isEmpty == false {
                record.append(field) // Add last field
            }
            if !record[0].isEmpty || !record[1].isEmpty || !record[2].isEmpty || !record[3].isEmpty {
                let r = TsvImportRow(
                    key_android: String(record[0]), 
                    key_apple: String(record[1]), 
                    base_value: String(record[2]), 
                    lang_value: String(record[3]),
                    comments: record.count > 4 ? String(record[4]) : ""
                )
                recordList.append(r) // Add last record
            }
            
        } catch {
            print(  "TsvImportSheet error:\n\(error)")
        }
        return recordList
    }
    
    mutating func parseUpdateAndroidKeys(recordList: [TsvImportRow]) -> [TsvImportRow] {
        var recordList = recordList
        for i in 0 ..< recordList.count {
            recordList[i].key_android = recordList[i].key_android.replacingOccurrences(
                of: "\\[(.*)\\]\\[(.*)\\]", 
                with: ".$1.$2", 
                options: .regularExpression)
            recordList[i].key_android = recordList[i].key_android.replacingOccurrences(
                of: "\\[(.*)\\]", 
                with: ".$1", 
                options: .regularExpression)
        }
        return recordList
    }

    mutating func parseUpdateAppleKeys(recordList: [TsvImportRow]) -> [TsvImportRow] {
        var recordList = recordList
        for i in 0 ..< recordList.count {
            //print(":BEFORE: \(recordList[i].key_apple)")
            recordList[i].key_apple = recordList[i].key_apple.replacingOccurrences(
                of: "\\[(.*)\\]\\[(.*)\\]", 
                with: ".$1.$2", 
                options: .regularExpression)
            recordList[i].key_apple = recordList[i].key_apple.replacingOccurrences(
                of: "\\[(.*)\\]", 
                with: ".$1", 
                options: .regularExpression)
            recordList[i].key_apple = recordList[i].key_apple.replacingOccurrences(
                of: "Serving.", 
                with: ".Serving.", 
                options: .regularExpression)
            recordList[i].key_apple = recordList[i].key_apple.replacingOccurrences(
                of: "VarietyText.", 
                with: ".Variety.Text.", 
                options: .regularExpression)
            recordList[i].key_apple = recordList[i].key_apple.replacingOccurrences(
                of: "segmentTitles.(.)", 
                with: "segmentTitles[$1]", 
                options: .regularExpression)
            // :!!!:NYI: Tweak Activity
            
            //print(":AFTER:  \(recordList[i].key_apple)")
        }
        return recordList
    }
    
    func saveTsvFile(url: URL, recordList: [TsvImportRow]) {
        let outputString = toTsv(recordList: recordList)
        let outputUrl = url
            .deletingPathExtension()
            .appendingPathExtension("\(Date.datestampyyyyMMddHHmm).tsv")
        do {
            try outputString.write(to: outputUrl, atomically: true, encoding: .utf8)
        } catch {
            logger.error(" \(error)")
        }
    }
        
    // MARK:- Watch Parsing Lines
    
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
