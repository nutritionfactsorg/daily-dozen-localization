//
//  TsvSheet.swift
//  AppLocalizerLib
//

import Foundation

struct TsvSheet: TsvProtocol {
    
    var tsvRowList = TsvRowList()
    let logger = LogService.shared
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
        var initNameList = ""
        for url in urlList {
            initNameList.append("\(url.lastPathComponent); ")
        }        
        var msg = """
        \n########################################
        ########################################
        TsvSheet INIT LIST (\(urlLanguage!.lastPathComponent)) \(initNameList)\n
        """
        for url in urlList {
            msg.append("TsvSheet PARSING: \(url.lastPathComponent)\n")
            var tmpTsvRowList = parseTsvFile(url: url)
            tmpTsvRowList = normalizeAndroidKeys(tsvRowList: tmpTsvRowList)
            tmpTsvRowList = normalizeAppleKeys(tsvRowList: tmpTsvRowList)
            tmpTsvRowList = removeDuplicatesExactMatch(tsvRowList: tmpTsvRowList)
            //writeTsvFile(tmpTsvRowList, baseTsvFileUrl: url)
            self.tsvRowList = merge(basis: self.tsvRowList, addin: tmpTsvRowList)
        }
        
        logger.info(msg)
        self.tsvRowList = self.tsvRowList.sorted()
        self.tsvRowList = removeDuplicatesExactMatch(tsvRowList: self.tsvRowList)
    }
    
    init(tsvRowList trl: TsvRowList) {
        self.urlLanguage = nil
        var tmpTsvRowList = trl
        tmpTsvRowList = normalizeAndroidKeys(tsvRowList: tmpTsvRowList)
        tmpTsvRowList = normalizeAppleKeys(tsvRowList: tmpTsvRowList)
        tmpTsvRowList = removeDuplicatesExactMatch(tsvRowList: tmpTsvRowList)
        self.tsvRowList = tmpTsvRowList
    }
    
    init(_ sheetList: [TsvSheet]) {
        self.urlLanguage = nil
        for sheet in sheetList {
            var tmpTsvRowList = sheet.tsvRowList
            tmpTsvRowList = normalizeAndroidKeys(tsvRowList: tmpTsvRowList)
            tmpTsvRowList = normalizeAppleKeys(tsvRowList: tmpTsvRowList)
            tmpTsvRowList = removeDuplicatesExactMatch(tsvRowList: tmpTsvRowList)
            self.tsvRowList = merge(basis: tsvRowList, addin: tmpTsvRowList)
        }
        self.tsvRowList = tsvRowList.sorted()
        self.tsvRowList = removeDuplicatesExactMatch(tsvRowList: self.tsvRowList)
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
            keySet.insert(r.primaryKey())
        }
        return keySet
    }
    
    func getLookupDictBaseNoteByPrimaryKey() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            d[r.primaryKey()] = r.base_note
        }
        return d
    }
    
    func getLookupDictBaseValueByPrimaryKey() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            d[r.primaryKey()] = r.base_value
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
    
    func getLookupDictLangValueByPrimaryKey() -> [String: String] {
        var d = [String: String]()
        for r in tsvRowList.data {
            d[r.primaryKey()] = r.lang_value
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
                r.key_android = newKey
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
            // change possible "..Serving" to ".Serving"
            r.key_apple = r.key_apple.replacingOccurrences( of: "..", with: ".", options: .literal)
            
            // "VarietyText." -> ".Variety.Text."
            r.key_apple = r.key_apple.replacingOccurrences(of: "VarietyText.", with: ".Variety.Text.", options: .literal)
            // "segmentTitles.0" -> "segmentTitles[0]"
            r.key_apple = r.key_apple.replacingOccurrences(of: "segmentTitles.(.)", with: "segmentTitles[$1]", options: .regularExpression)
            
            // .Imperial -> .imperial
            r.key_apple = r.key_apple.replacingOccurrences(of: ".Imperial", with: ".imperial", options: .literal)
            // .Metric -> .metric
            r.key_apple = r.key_apple.replacingOccurrences(of: ".Metric", with: ".metric", options: .literal)
            // .Topic -> .topic
            r.key_apple = r.key_apple.replacingOccurrences(of: ".Topic", with: ".topic", options: .literal)
            
            // :!!!:NYI: Tweak Activity
            
            //if watch {
            //    print(":WATCH:AFTER: \(r.key_apple)")
            //}
            
            newTsvRowList.append(r)
        }
        return newTsvRowList
    }
    
    /// 
    func merge(basis: TsvRowList, addin: TsvRowList) -> TsvRowList {
        var mergeResult = TsvRowList()
                
        let basisRows = basis.sortedByPrimaryKey().data
        let addinRows = addin.sortedByPrimaryKey().data
        
        var i = 0
        var j = 0
        while i < basisRows.count && j < addinRows.count {
            let basisKey = basisRows[i].primaryKey()
            let addinKey = addinRows[j].primaryKey()
            if basisKey == addinKey {
                mergeResult.append(addinRows[j])
                i += 1
                j += 1
            } else if basisKey < addinKey {
                mergeResult.append(basisRows[i])
                i += 1
            } else {
                mergeResult.append(addinRows[j])
                j += 1
            }            
        }
        while i < basisRows.count {
            mergeResult.append(basisRows[i])
            i += 1
        }
        while j < addinRows.count {
            mergeResult.append(addinRows[j])
            j += 1
        }
        
        return mergeResult
    }
    
    func removeDuplicatesExactMatch(tsvRowList: TsvRowList) -> TsvRowList {
        guard tsvRowList.data.count >= 1 else {
            print(":WARNING: TsvSheet.removeDuplicates() tsvRowList has less than 1 rows.")
            return tsvRowList
        }
        
        var resultTRL = TsvRowList()
        let trl = tsvRowList.sorted()
        
        var idx = 0
        var rowPrior = trl.data[idx]
        resultTRL.append(rowPrior)
        
        idx += 1
        while idx < trl.data.count {
            let rowCurrent: TsvRow = trl.data[idx]
            
            if rowCurrent != rowPrior {
                resultTRL.append(rowCurrent)
                rowPrior = rowCurrent
            }
            idx += 1
        }
        
        reportRowDuplicateKeys(tsvRowList: resultTRL)
        return resultTRL
    }
    
    func reportRowDuplicateKeys(tsvRowList: TsvRowList) {
        guard tsvRowList.data.count >= 1 else {
            print(":WARNING: TsvSheet.reportRowDuplicates(…) tsvRowList has less than 1 rows.")
            return
        }
        
        reportRowDuplicateAppleKey(tsvRowList: tsvRowList)
        reportRowDuplicateDroidKey(tsvRowList: tsvRowList)
        //reportRowDuplicateLang(tsvRowList: tsvRowList) // long list of reused values
    }
    
    private func reportRowDuplicateAppleKey(tsvRowList: TsvRowList) {
        let trl = tsvRowList.sorted()
        var report = ""        
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
        if report.isEmpty == false {
            logger.info("""
            \n########################################
            ### REPORT/TSV: Duplicate Apple Keys ###
            \(report)\n
            """)
        }
    }
    
    private func reportRowDuplicateDroidKey(tsvRowList: TsvRowList) {
        let trl = tsvRowList.sortedByAndroid()
        var report = ""
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
        if report.isEmpty == false {
            logger.info("""
            \n##########################################
            ### REPORT/TSV: Duplicate Android Keys ###
            \(report)\n
            """)
        }
    }
    
    /// long list: many values are the same for different keys.
    private func reportRowDuplicateLang(tsvRowList: TsvRowList) {
        let trl = tsvRowList.sortedByLang()
        var report = ""
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
                
                let keyCurrent = rowCurrent.key_apple.lowercased()
                let keyPrior = rowPrior.key_apple.lowercased()
                if (keyCurrent.contains("metric") && keyPrior.contains("imperial")) ||
                    (keyCurrent.contains("imperial") && keyPrior.contains("metric"))
                {
                    idx += 1
                    continue
                }
                
                report.append("\(rowPrior.toStringDot(includeNotes: true))\n")
                report.append("\(rowCurrent.toStringDot(includeNotes: true))\n")
                report.append("\n")
            }
            rowPrior = rowCurrent
            idx += 1
        }
        if report.isEmpty == false {
            logger.info("""
            \n#############################################
            ### REPORT/TSV: duplicate Lang-Base Pairs ###
            ### Note: may simply be imperial vs metric\n
            \(report)\n
            """)
        }
    }
    
    
    // MARK: - Operations
    
    // no TsvProtocol overrides
    
    /// Update this TsvSheet with `base_note` data from the given `fromSheet`.
    /// 
    /// Use to refresh this TsvSheet with data from the the English reference.
    /// 
    /// Prerequisite:  `key_apple` and `key_android` fields must be up-to-date in both  `TsvSheets`
    mutating func updateBaseNotes(_ fromSheet: TsvSheet) {
        if urlLanguage?.lastPathComponent == "English_US" {
            return // Skip the English_US. Will always match self.
        }
        let baseNoteFromDict = fromSheet.getLookupDictBaseNoteByPrimaryKey()
        var infoFromUKeyNotPresent = [TsvRow]()
        var infoIntoNoteChanged = [(old:TsvRow, new: String)]()
        for idx in 0 ..< tsvRowList.data.count {
            let rCopy = tsvRowList.data[idx]
            guard let noteFrom = baseNoteFromDict[rCopy.primaryKey()] else {
                infoFromUKeyNotPresent.append(rCopy)
                continue
            }
            let noteInto = rCopy.base_note // this TsvSheet is the target
            if noteInto == noteFrom {
                continue // nothing to change. nothing to report.
            } else {
                // update `base_note` from the reference sheet.
                tsvRowList.data[idx].base_note = noteFrom
                infoIntoNoteChanged.append((old: rCopy, new: noteFrom))
            }
        }
        
        if !infoFromUKeyNotPresent.isEmpty || !infoIntoNoteChanged.isEmpty {
            let filename = "\(urlLanguage?.lastPathComponent ?? "?")"
            let fromName = "\(fromSheet.urlLanguage?.lastPathComponent ?? "?")"
            var s = "\n"
            if infoFromUKeyNotPresent.isEmpty == false {
                s += "##########################################################\n"
                s += "### ‘BASE_NOTE’ PRIMARY_KEY NOT FOUND IN \(fromName)\n"
                s += "##########################################################\n"
                s += "### when processing \(filename) given \(fromName)\n"
                for rCopy in infoFromUKeyNotPresent {
                    s += "KEY(\(rCopy.primaryKey()))\n"
                }
            }
            if infoIntoNoteChanged.isEmpty == false {
                s += "###########################\n"
                s += "### ‘BASE_NOTE’ CHANGED ###\n"
                s += "###########################\n"
                s += "### when processing \(filename) given \(fromName)\n"
                for changed in infoIntoNoteChanged {
                    s += "KEY(\(changed.old.primaryKey()))\n"
                    s += "OLD:\(changed.old.base_note)\n"
                    s += "NEW:\(changed.new)\n"
                    s += "\n"            
                }
            }            
            logger.info(s)
        }
    }
    
    /// Update this "into" TsvSheet with `base_value` data from the given `fromSheet`.
    /// 
    /// If this "into" TsvSheet has `base_value` == `lang_value`,
    /// then both the `base_value` and `lang_value` are also updated. 
    /// This is the case where the `English_US` is untranslated.
    /// 
    /// Use to refresh this TsvSheet with data from the the English reference.
    /// 
    /// Prerequisite:  `key_apple` and `key_android` fields must be up-to-date in both  `TsvSheets`
    mutating func updateBaseValues(_ fromSheet: TsvSheet) {
        if urlLanguage?.lastPathComponent == "English_US" {
            return // Skip the English_US. Will always match itself.
        }
        let baseValueFromDict = fromSheet.getLookupDictBaseValueByPrimaryKey()
        var infoFromEmpty = [TsvRow]()
        var infoFromUKeyNotPresent = [TsvRow]()
        var infoIntoBaseChanged = [(old:TsvRow, new: String)]()
        var infoIntoLangChanged = [(old:TsvRow, new: String)]()
        for idx in 0 ..< tsvRowList.data.count {
            let rCopy = tsvRowList.data[idx]
            guard let baseValueFrom = baseValueFromDict[rCopy.primaryKey()] else {
                infoFromUKeyNotPresent.append(rCopy)
                continue
            }
            let baseValueInto = rCopy.base_value // this TsvSheet is the "into" target
            let langValueInto = rCopy.lang_value
            if baseValueInto == baseValueFrom {
                continue // nothing to change. nothing to report.
            } else if baseValueInto.isEmpty {
                // updates empty target. no reporting needed
                tsvRowList.data[idx].base_value = baseValueFrom
                if baseValueInto == langValueInto {
                    tsvRowList.data[idx].lang_value = baseValueFrom
                }
            } else if baseValueFrom.isEmpty {
                // empty source would empty non-empty target. needs to be reported.
                infoFromEmpty.append(rCopy)
            } else {
                // source changes non-empty target. needs to be reported.
                tsvRowList.data[idx].base_value = baseValueFrom
                infoIntoBaseChanged.append((old: rCopy, new: baseValueFrom))
                if baseValueInto == langValueInto {
                    tsvRowList.data[idx].lang_value = baseValueFrom // same, same
                    infoIntoLangChanged.append((old: rCopy, new: baseValueFrom))
                }
            }
        }
        
        if !infoFromEmpty.isEmpty || !infoFromUKeyNotPresent.isEmpty || !infoIntoBaseChanged.isEmpty || !infoIntoLangChanged.isEmpty {
            let filename = "\(urlLanguage?.lastPathComponent ?? "?")"
            let fromName = "\(fromSheet.urlLanguage?.lastPathComponent ?? "?")"
            var s = "\n"
            if infoFromEmpty.isEmpty == false {
                s += "##############################################\n"
                s += "### ‘BASE_VALUE’ FROM (reference) IS EMPTY ###\n"
                s += "##############################################\n"
                s += "### when processing \(filename) given \(fromName)\n"
                for rCopy in infoFromEmpty {
                    s += "KEY(\(rCopy.primaryKey()))\n"
                }
            }
            if infoFromUKeyNotPresent.isEmpty == false {
                s += "#################################################################\n"
                s += "### ‘BASE_VALUE’ PRIMARY_KEY NOT FOUND IN \(fromName)\n"
                s += "#################################################################\n"
                s += "### when processing \(filename) given \(fromName)\n"
                for rCopy in infoFromUKeyNotPresent {
                    s += "KEY(\(rCopy.primaryKey()))\n"
                }
            }
            if infoIntoBaseChanged.isEmpty {
                s += "############################\n"
                s += "### ‘BASE_VALUE’ CHANGED ###\n"
                s += "############################\n"
                s += "### when processing \(filename) given \(fromName)\n"
                for changed in infoIntoBaseChanged {
                    s += "KEY(\(changed.old.primaryKey()))\n"
                    s += "OLD: \(changed.old.base_value)\n"
                    s += "NEW: \(changed.new)\n"
                    s += "\n"
                }
            }
            if infoIntoLangChanged.isEmpty {
                s += "############################\n"
                s += "### ‘LANG_VALUE’ CHANGED ###\n"
                s += "############################\n"
                s += "### when processing \(filename) given \(fromName)\n"
                for changed in infoIntoLangChanged {
                    s += "(KEY(\(changed.old.primaryKey()))\n"
                    s += "OLD: \(changed.old.lang_value)\n"
                    s += "NEW: \(changed.new)\n"
                    s += "\n"
                }
            }
            
            logger.info(s)
        }
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
        guard let content = try? String(contentsOf: url, encoding: .utf8)
        else {
            print(  "TsvSheet failed to read: \(url.path)")
            fatalError()
        }
        
        if content.contains("\"\"") {
            print(":ERROR: TsvSheet escaped quoting is not supported \(url.absoluteString)")
            fatalError()
        }
        
        let rows = content.components(separatedBy: CharacterSet.newlines)
        if rows.count < 2 {
            print(":ERROR: TsvSheet contains less than 2 lines \(url.absoluteString)")
            fatalError()
        }
        if rows[0].hasPrefix("key_droid\tkey_apple\tbase_value\tlang_value") == false {
            print(":ERROR: TsvSheet is missing the header row \(url.absoluteString)")
            fatalError()
        }
        
        for i in 1 ..< rows.count {
            let columns = rows[i].components(separatedBy: "\t")
            
            // Requires either an Android key or an Apple key
            if columns.count >= 4 {
                // must contain a value for at least one of `key_droid` or `key_apple`
                if columns[0].isEmpty == false || columns[1].isEmpty == false {
                    let r = TsvRow(
                        key_android: columns[0],
                        key_apple: columns[1],
                        base_value: columns[2],
                        lang_value: columns[3],
                        base_note: columns.count > 4 ? columns[4] : "", 
                        lang_note: columns.count > 5 ? columns[5] : ""
                    )
                    recordList.append(r) // Add last record
                }
            }
        }
        
        return TsvRowList(data: recordList)
    }
    
}
