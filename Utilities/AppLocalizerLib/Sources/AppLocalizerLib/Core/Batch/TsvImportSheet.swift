//
//  TsvImportSheet.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvImportSheet {
    var recordList: [TsvImportRow] = []
    var logger = LogService()
                
    init(url: URL, loglevel: LogServiceLevel = .info) {
        logger.logLevel = loglevel
        parseTsvFile(url: url)
        parseUpdateAndroidKeys()
        parseUpdateAppleKeys()
        saveTsvFile(url: url)
    }
    
    func checkKeyCoverageAndroid(xmlKeys: Set<String>) {
        var tsvKeys = Set<String>()
        var s = ""
        for r in recordList {
            let key = r.key_android
            if tsvKeys.contains(key) {
                s.append(" \(key)\n)")
            } else {
                tsvKeys.insert(key)
            }
        }
        if s.isEmpty {
            print("#####\nDuplicate TSV Android Keys: NONE\n")
        } else {
            print("#####\nDuplicate TSV Android Keys: \(s)\n#####\n")
        }
        
        let tsvExtras = tsvKeys.subtracting(xmlKeys)
        if tsvExtras.isEmpty {
            print("#####\nExtra TSV Android Keys: NONE\n")
        } else {
            s = "#####\nExtra TSV Android Keys:\n"
            for key in tsvExtras {
                s.append(" \(key)\n")
            }
            s.append("#####\n")
            print(s)
        }
        
        let tsvMissing = xmlKeys.subtracting(tsvKeys)
        if tsvMissing.isEmpty {
            print("#####\nMissing TSV Android Keys: NONE\n")
        } else {
            s = "#####\nMissing TSV Android Keys:\n"
            for key in tsvMissing {
                s.append(" \(key)\n")
            }
            s.append("#####\n")
            print(s)
        }
    }
    
    func checkKeyCoverageApple(xmlKeys: Set<String>) {
        var tsvKeys = Set<String>()
        var s = ""
        for r in recordList {
            let key = r.key_apple
            if tsvKeys.contains(key) {
                s.append(" \(key)\n)") 
            } else {
                tsvKeys.insert(key)
            }
        }
        if s.isEmpty {
            print("#####\nDuplicate TSV Apple Keys: NONE\n")
        } else {
            print("#####\nDuplicate TSV Apple Keys: \(s)\n#####\n")
        }
        
        let tsvExtras = tsvKeys.subtracting(xmlKeys)
        if tsvExtras.isEmpty {
            print("#####\nExtra TSV Apple Keys: NONE\n")
        } else {
            s = "#####\nExtra TSV Apple Keys:\n"
            for key in tsvExtras {
                s.append(" \(key)\n")
            }
            s.append("#####\n")
            print(s)
        }
        
        let tsvMissing = xmlKeys.subtracting(tsvKeys)
        if tsvMissing.isEmpty {
            print("#####\nMissing TSV Apple Keys: NONE\n")
        } else {
            s = "#####\nMissing Apple TSV Keys:\n"
            for key in tsvMissing {
                s.append(" \(key)\n")
            }
            s.append("#####\n")
            print(s)
        }
    }

    func getLookupDictAndroid() -> [String: String] {
        var d = [String: String]()
        for r in recordList {
            d[r.key_android] = r.lang_value
        }
        return d
    }
    
    func getLookupDictApple() -> [String: String] {
        var d = [String: String]()
        for r in recordList {
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
        for r in recordList {
            s.append("record[\(index)]:\n\(r.toString())\n")
            index += 1
        }
        return s
    }
    
    func toStringDot() -> String {
        var s = ""
        for r in recordList {
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

    func toTsv() -> String {
        var s = ""
        for r in recordList {
            s.append(r.toTsv())
        }
        return s
    } 
    
    // MARK:- Parsing
    
    mutating func parseTsvFile(url: URL) {
        let newline: Set<Character> = ["\n", "\r", "\r\n"]
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            // .split(whereSeparator: (Character) throws -> Bool)
            // Value of type 'String.Element' (aka 'Character') has no member 'isNewLine'
            
            if content.count < 100 {
                print(":ERROR: TsvImportSheet did not init with \(url.absoluteString)")
                return
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
                        if record.count >= 4 {
                            if !record[0].isEmpty || !record[1].isEmpty || !record[2].isEmpty || !record[3].isEmpty {
                                // Add non-empty record to list.
                                let r = TsvImportRow(
                                    key_android: String(record[0]), 
                                    key_apple: String(record[1]), 
                                    base_value: String(record[2]), 
                                    lang_value: String(record[3])
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
                    lang_value: String(record[3])
                )
                recordList.append(r) // Add last record
            }
            
        } catch {
            print(  "TsvImportSheet error:\n\(error)")
        }
    }
    
    mutating func parseUpdateAndroidKeys() {
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
    }

    mutating func parseUpdateAppleKeys() {
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
    }
    
    func saveTsvFile(url: URL) {
        let outputString = toTsv()
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
