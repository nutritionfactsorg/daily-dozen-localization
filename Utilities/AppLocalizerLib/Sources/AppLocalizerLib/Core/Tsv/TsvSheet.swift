//
//  TsvSheet.swift
//  AppLocalizerLib
//

import Foundation

struct TsvSheet: TsvProtocol {
    
    var tsvRowList = TsvRowList()
    var logger = LogService()
    var urlLanguage: URL? // specific language URL, e.g. …/Languages/English_us
    
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
            tmpTsvRowList = removeDuplicates(tsvRowList: tmpTsvRowList)
            //writeTsvFile(tmpTsvRowList, baseTsvFileUrl: url)
            tsvRowList.append(contentsOf: tmpTsvRowList)
        }
        tsvRowList = tsvRowList.sorted()
        tsvRowList = removeDuplicates(tsvRowList: tsvRowList)
    }
    
    init(tsvRowList trl: TsvRowList) {
        self.urlLanguage = nil
        var tmpTsvRowList = trl
        tmpTsvRowList = normalizeAndroidKeys(tsvRowList: tmpTsvRowList)
        tmpTsvRowList = normalizeAppleKeys(tsvRowList: tmpTsvRowList)
        tmpTsvRowList = removeDuplicates(tsvRowList: tmpTsvRowList)
        self.tsvRowList = tmpTsvRowList
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
        return Set<String>(getLookupDictLangValueByAndroidKey().keys)
    }
    
    func getKeySetApple() -> Set<String> {
        return Set<String>(getLookupDictLangValueByAppleKey().keys)
    }
    
    func getKeySetPrimary() -> Set<String> {
        var keySet = Set<String>()
        for r in tsvRowList.data {
            keySet.insert("\(r.key_apple)&\(r.key_android)")
        }
        return keySet
    }
    
    func getLookupDictBaseNoteByUniqueKey() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            let uniqueKey = "\(r.key_apple)&\(r.key_android)"
            d[uniqueKey] = r.base_note
        }
        return d
    }
    
    func getLookupDictBaseValueByUniqueKey() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            let uniqueKey = "\(r.key_apple)&\(r.key_android)"
            d[uniqueKey] = r.base_value
        }
        return d
    }
    
    func getLookupDictLangValueByAndroidKey() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            if r.key_android.isEmpty == false {
                d[r.key_android] = r.lang_value
            }
        }
        return d
    }
    
    func getLookupDictLangValueByAppleKey() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            if r.key_apple.isEmpty == false {
                d[r.key_apple] = r.lang_value                
            }
        }
        return d
    }
    
    func getLookupDictLangValueByUniqueKey() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            let uniqueKey = "\(r.key_apple)&\(r.key_android)"
            d[uniqueKey] = r.lang_value
        }
        return d
    }
    
    func getTsvRowDict() -> (apple: [String : TsvRow], droid: [String : TsvRow], paired: [String : TsvRow]) {
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
    
    func removeDuplicates(tsvRowList: TsvRowList) -> TsvRowList {
        guard tsvRowList.data.count >= 2 else {
            print(":WARNING: TsvSheet.removingDuplicates() tsvRowList has less than 2 rows.")
            return tsvRowList
        }
        
        var resultTRL = TsvRowList()
        let trl = tsvRowList.sorted()
        
        var idx = 0
        var rowPrior = trl.data[idx]
        resultTRL.append(rowPrior)
        
        idx += 1
        while idx < trl.data.count {
            let rowCurrent = trl.data[idx]
            
            if rowCurrent != rowPrior {
                resultTRL.append(rowCurrent)
                rowPrior = rowCurrent
            }
            idx += 1
        }
        
        reportRowDuplicates(tsvRowList: resultTRL)
        return resultTRL
    }
    
    func reportRowDuplicates(tsvRowList: TsvRowList) {
        guard tsvRowList.data.count >= 2 else {
            print(":WARNING: TsvSheet.reportRowDuplicates(…) tsvRowList has less than 2 rows.")
            return
        }
        
        reportRowDuplicateAppleKey(tsvRowList: tsvRowList)
        reportRowDuplicateDroidKey(tsvRowList: tsvRowList)
        reportRowDuplicateLang(tsvRowList: tsvRowList)
    }
    
    private func reportRowDuplicateAppleKey(tsvRowList: TsvRowList) {
        let trl = tsvRowList.sorted()
        var report = """
        \n########################################
        ### DUPLICATE TSV REPORT: Apple Keys ###\n
        """
        
        var idx = 0
        var rowPrior = trl.data[idx]
        
        idx += 1
        while idx < trl.data.count {
            let rowCurrent: TsvRow = trl.data[idx]
            
            if rowCurrent.key_apple.isEmpty  {
                idx += 1
                continue
            }
            
            if rowCurrent.key_apple == rowPrior.key_apple {
                report.append("\(rowPrior.toStringDot(includeNotes: true))\n")
                report.append("\(rowCurrent.toStringDot(includeNotes: true))\n")
                report.append("\n")
            }
            rowPrior = rowCurrent
            idx += 1
        }
        print(report)
    }
    
    private func reportRowDuplicateDroidKey(tsvRowList: TsvRowList) {
        let trl = tsvRowList.sortedByAndroid()
        var report = """
        \n##########################################
        ### DUPLICATE TSV REPORT: Android Keys ###\n
        """
        
        var idx = 0
        var rowPrior = trl.data[idx]
        
        idx += 1
        while idx < trl.data.count {
            let rowCurrent: TsvRow = trl.data[idx]
            
            if rowCurrent.key_android.isEmpty  {
                idx += 1
                continue
            }
            
            if rowCurrent.key_android == rowPrior.key_android {
                report.append("\(rowPrior.toStringDot(includeNotes: true))\n")
                report.append("\(rowCurrent.toStringDot(includeNotes: true))\n")
                report.append("\n")
            }
            rowPrior = rowCurrent
            idx += 1
        }
        print(report)        
    }
    
    private func reportRowDuplicateLang(tsvRowList: TsvRowList) {
        let trl = tsvRowList.sortedByLang()
        var report = """
        \n#############################################
        ### DUPLICATE TSV REPORT: Lang-Base Pairs ###
        ### Note: may simply be imperial vs metric\n
        """
        
        var idx = 0
        var rowPrior = trl.data[idx]
        
        idx += 1
        while idx < trl.data.count {
            let rowCurrent: TsvRow = trl.data[idx]
            
            if rowCurrent.base_value.isEmpty && rowCurrent.lang_value.isEmpty {
                idx += 1
                continue
            }
            
            if rowCurrent.lang_value == rowPrior.lang_value &&
                rowCurrent.base_value == rowPrior.base_value {
                report.append("\(rowPrior.toStringDot(includeNotes: true))\n")
                report.append("\(rowCurrent.toStringDot(includeNotes: true))\n")
                report.append("\n")
            }
            rowPrior = rowCurrent
            idx += 1
        }
        print(report)        
    }
    
    
    // MARK: - Operations
    
    // no TsvProtocol overrides
    
    /// Prerequisite:  `key_apple` and `key_android` fields must be up-to-date in both  `TsvSheets`
    mutating func updateBaseNotes(_ notesSheet: TsvSheet) {
        if urlLanguage?.lastPathComponent == "English_US" {
            return // Skip the English_US. Will always match self.
        }
        let baseNoteFromDict = notesSheet.getLookupDictBaseNoteByUniqueKey()
        var listFromEmpty = [TsvRow]()
        var listFromNotPresent = [TsvRow]()
        var listIntoChanged = [(from: String, into:TsvRow)]()
        for idx in 0 ..< tsvRowList.data.count {
            let r = tsvRowList.data[idx]
            let uniqueKey = "\(r.key_apple)&\(r.key_android)"
            guard let noteFrom = baseNoteFromDict[uniqueKey] else {
                listFromNotPresent.append(r)
                continue
            }
            let noteInto = r.base_note // this TsvSheet is the target
            if noteInto == noteFrom {
                continue // nothing to change. nothing to report.
            } else if noteInto.isEmpty {
                // updates empty target. no reporting needed
                tsvRowList.data[idx].base_note = noteFrom
            } else if noteFrom.isEmpty {
                // empty source would empty non-empty target. needs to be reported.
                listFromEmpty.append(r)
            } else {
                // source changes non-empty target. needs to be reported.
                tsvRowList.data[idx].base_note = noteFrom
                listIntoChanged.append((from: noteFrom, into: r))
            }
        }
        var s = "\n"
        s += "##############################\n"
        s += "### ‘BASE_NOTE’ Language: \(urlLanguage?.lastPathComponent ?? "")\n"
        s += "##############################\n"
        s += "### ‘BASE_NOTE’ FROM EMPTY ###\n"
        s += "##############################\n"
        for r in listFromEmpty {
            s += "\(r.key_android)\t\(r.key_android)\t\(r.base_value)\n"
        }
        s += "####################################\n"
        s += "### ‘BASE_NOTE’ FROM NOT PRESENT ###\n"
        s += "####################################\n"
        for r in listFromNotPresent {
            s += "\(r.key_android)\t\(r.key_android)\t\(r.base_value)\n"
        }
        s += "###########################\n"
        s += "### ‘BASE_NOTE’ CHANGED ###\n"
        s += "###########################\n"
        for changed in listIntoChanged {
            let r = changed.into
            s += "\(r.key_android)\t\(r.key_android)\t\(r.base_value)\n"
            s += "FROM: \(changed.from)\n"
            s += "INTO: \(r.base_note)\n"
            s += "\n"            
        }
        
        print(s)
    }
    
    /// Prerequisite:  `key_apple` and `key_android` fields must be up-to-date in both  `TsvSheets`
    mutating func updateBaseValues(_ baseSheet: TsvSheet) {
        if urlLanguage?.lastPathComponent == "English_US" {
            return // Skip the English_US. Will always match self.
        }
        let baseValueFromDict = baseSheet.getLookupDictBaseValueByUniqueKey()
        var listFromEmpty = [TsvRow]()
        var listFromNotPresent = [TsvRow]()
        var listIntoChanged = [(from: String, into:TsvRow)]()
        for idx in 0 ..< tsvRowList.data.count {
            let r = tsvRowList.data[idx]
            let uniqueKey = "\(r.key_apple)&\(r.key_android)"
            guard let valueFrom = baseValueFromDict[uniqueKey] else {
                listFromNotPresent.append(r)
                continue
            }
            let valueInto = r.base_value // this TsvSheet is the target
            if valueInto == valueFrom {
                continue // nothing to change. nothing to report.
            } else if valueInto.isEmpty {
                // updates empty target. no reporting needed
                tsvRowList.data[idx].base_value = valueFrom
            } else if valueFrom.isEmpty {
                // empty source would empty non-empty target. needs to be reported.
                listFromEmpty.append(r)
            } else {
                // source changes non-empty target. needs to be reported.
                tsvRowList.data[idx].base_value = valueFrom
                listIntoChanged.append((from: valueFrom, into: r))
            }
        }
        var s = "\n"
        s += "##############################\n"
        s += "### ‘BASE_VALUE’ Language: \(urlLanguage?.lastPathComponent ?? "")\n"
        s += "##############################\n"
        s += "### ‘BASE_VALUE’ FROM EMPTY ###\n"
        s += "##############################\n"
        for r in listFromEmpty {
            s += "\(r.key_android)\t\(r.key_android)\t\(r.base_value)\n"
        }
        s += "####################################\n"
        s += "### ‘BASE_VALUE’ FROM NOT PRESENT ###\n"
        s += "####################################\n"
        for r in listFromNotPresent {
            s += "\(r.key_android)\t\(r.key_android)\t\(r.base_value)\n"
        }
        s += "###########################\n"
        s += "### ‘BASE_VALUE’ CHANGED ###\n"
        s += "###########################\n"
        for changed in listIntoChanged {
            let r = changed.into
            s += "\(r.key_android)\t\(r.key_android)\t\(r.base_value)\n"
            s += "FROM: \(changed.from)\n"
            s += "INTO: \(r.base_value)\n"
            s += "\n"            
        }
        
        print(s)
    }
    
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
        guard let content = try? String(contentsOf: url, encoding: .utf8)
        else {
            print(  "TsvSheet failed to read: \(url.path)")
            fatalError()
        }
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
        
        for character: Character in content {
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
                                base_note: record[4],
                                lang_note: record.count > 5 ? record[5] : ""
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
                            // Note: look for regex cases of `tab + double-quote` (`\t"`)
                            // Use single quote where applicable e.g. notes.
                            // Otherwise tsv-escape quotes ("") or evolve this parser
                            // CotEditor handles mixed direction texts better than BBEdit
                            fatalError(
                            """
                            \n::ERROR: TsvSheet escaped quote must precede
                            :@dotStr: \(toStringDot(field:field))\n\n
                            :@line: \(lineIdx)[\(lineCharIdx)]
                            :@path: \(url.path)
                            """)
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
        if record.count >= 4 {
            if !record[0].isEmpty || !record[1].isEmpty {
                let r = TsvRow(
                    key_android: record[0],
                    key_apple: record[1],
                    base_value: record[2],
                    lang_value: record[3],
                    base_note: record.count > 4 ? record[4] : "", 
                    lang_note: record.count > 5 ? record[5] : ""
                )
                recordList.append(r) // Add last record
            }
        }
        
        return TsvRowList(data: recordList)
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
