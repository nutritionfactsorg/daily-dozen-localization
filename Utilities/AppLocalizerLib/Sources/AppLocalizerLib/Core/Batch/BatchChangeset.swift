//  File: BatchChangeset.swift
//  AppLocalizerLib

import Foundation

/// Batch Changeset Processor
struct BatchChangeset {
    static var shared = BatchChangeset()
    let logger = LogService.shared
    
    /// Baseline TSV sheet: `English_US` fully reviewed & up-to-date
    var baseTsvSheet: TsvSheet? = nil
    var deleteSet: Set<String> = []
    var insertList: Array<TsvRow> = []
    
    /// Language TSV sheet urls
    var langInputTsvUrl: URL? = nil
    var langOutputTsvUrl: URL? = nil
    var langStr: String {
        guard let langOut = langOutputTsvUrl
        else {
            return "UNKNOWN"
        }
        let filename = langOut.lastPathComponent
        //let lang = String(filename.split(separator: ".", maxSplits: 1).first ?? "")
        let lang = String(filename.firstMatch(of: #/^[^.]+/#)?.0 ?? "")
        return lang
    }
    
    var outputCacheLocalDir: URL? // Batch: `Languages/../_CACHE__LOCAL/`
    
    /// Multiple Combined Changesets
    var multiChangesets: [TsvRow] = []
    
    mutating func addBaseTsvSheet(_ sheet: TsvSheet) {
        writeTsv(sheet.tsvRowList.data, filename: "90_baseDataAsis")
        let tsvRowList = sheet.tsvRowList.sortedByApple()
        writeTsv(tsvRowList.data, filename: "91_basePrimaryKeySorted")
        let tsvReindex = applyReindex(resultAfterInsert: tsvRowList.data)
        writeTsv(tsvReindex, filename: "92_baseReindexed")
        let newSheet = TsvSheet(tsvRows: tsvReindex)
        baseTsvSheet = newSheet
    }
    
    /// `DO_CHANGESET_APPLY_TSV`
    mutating func doChangesetApply() {
        guard
            let baseSheet = baseTsvSheet,
            let inputUrl = langInputTsvUrl, 
            let outputUrl = langOutputTsvUrl
        else {
            print(
            """
            \nERROR: doChangesetApply(…)
                Requires CS_BASE_TSV, CS_LANG_INPUT_TSV, and CS_LANG_OUTPUT_TSV\n
            """)
            return
        }
        
        // --- read & parse sourceListTsv -> sourceSheet
        var inputSheet: TsvSheet =  TsvSheet(inputUrl)
        writeTsv(inputSheet.tsvRowList.data, filename: "01_inputSheet")
        
        // --- SORT --- 
        // TsvSheet sorted sorted and deduplicated via init()
        //deleteSet = deleteSet.sortedByKeyParts()
        //insertSet = insertSet.sortedByKeyParts()
        
        // --- APPLY DELETES ---        
        let resultAfterDelete = applyDeletes(inputRows: inputSheet.tsvRowList.data)
        writeTsv(resultAfterDelete, filename: "02_afterDelete")
        
        // --- APPLY INSERTS ---
        let resultAfterInsert = applyInserts(resultAfterDelete: resultAfterDelete)
        writeTsv(resultAfterInsert, filename: "03_afterInsert")
                
        // --- REINDEX ---
        let resultAfterReindex = applyReindex(resultAfterInsert: resultAfterInsert)
        writeTsv(resultAfterReindex, filename: "04_afterReindex")
        
        // --- SYNC BASE ---
        writeTsv(baseSheet.tsvRowList.data, filename: "05_baseSheet")
        let resultAfterSyncBase = applySyncWithBase(reindexResult: resultAfterReindex, base: baseSheet.tsvRowList.data)
        writeTsv(resultAfterSyncBase.lang, filename: "06_afterSyncBase")
        writeTsv(resultAfterSyncBase.delta, filename: "07_delta")
                
        // Reset for next language
        langInputTsvUrl = nil
        langOutputTsvUrl = nil
    }

    /// `DO_CHANGESET_WRITE_MULTI_TSV`
    func doChangesetWriteMulti(toUrl: URL) {
        let multi = TsvSheet(tsvRowList: TsvRowList(data: multiChangesets))
        multi.writeTsvFile(toUrl)
    }

    /// `DO_CHANGESET_INTAKE_MULTI` after translations are complete.
    func doChangesetIntakeMulti() {
        fatalError("doChangesetIntakeMulti() is not yet implemented.")
    }
    
    /// --- APPLY DELETES ---
    /// let inputRows = inputSheet.tsvRowList.data
    /// applyDeletes(inputRows: inputRows)
    func applyDeletes(inputRows: [TsvRow]) -> [TsvRow] {
        var resultAfterDelete = [TsvRow]()
        for row: TsvRow in inputRows {
            if deleteSet.contains(row.key_apple) == false {
                resultAfterDelete.append(row)
            }
        }
        return resultAfterDelete
    }
    
    /// --- APPLY INSERTS ---
    func applyInserts(resultAfterDelete: [TsvRow]) -> [TsvRow] {
        var inputIdx = 0
        var insertIdx = 0
        var resultAfterInsert = [TsvRow]()
        
        var rowA = resultAfterDelete[inputIdx]
        var rowB = insertList[insertIdx]
        while inputIdx < resultAfterDelete.count && insertIdx < insertList.count {
            rowA = resultAfterDelete[inputIdx]
            rowB = insertList[insertIdx]
            
            // skip cases without an Apple key
            if rowA.key_apple.isEmpty {
                resultAfterInsert.append(rowA)
                inputIdx += 1
                continue
            }
            
            let relation = rowA.key_apple.keyOrderRelation(to: rowB.key_apple)
            switch relation {
            case .lessThan:
                resultAfterInsert.append(rowA)
                inputIdx += 1
                
            case .equalTo, .greaterThan:
                // adds an empty row to be filled later
                resultAfterInsert.append(rowB)
                resultAfterInsert.append(rowA)
                inputIdx += 1
                insertIdx += 1
            }            
        }
        while inputIdx < resultAfterDelete.count {
            rowA = resultAfterDelete[inputIdx]
            resultAfterInsert.append(rowA)
            inputIdx += 1
        }
        while insertIdx < insertList.count {
            rowB = insertList[insertIdx]
            resultAfterInsert.append(rowB)
            insertIdx += 1
        }
        return resultAfterInsert
    }
    
    /// LIMIT:
    ///     - Reindexing is only based `row.key_apple`.
    ///     -any mismatching `key_android` and `key_apple` indices are logged.
    func applyReindex(resultAfterInsert tsvRowList: [TsvRow]) -> [TsvRow] {
        // Dictionary to track the next index for each namePart
        var indexCounters: [String: Int] = [:]
        // Result
        var resultAfterReindex = [TsvRow]()
        
        for var row in tsvRowList {
            let (nameAndroid, indexAndroid) = row.key_android.keyParts()
            let (nameApple, indexApple) = row.key_apple.keyParts()
            
            if indexAndroid != indexApple {
                logger.error("non-matching key indices:\n\(row)")
            }
            
            // If there's no index part, keep the string as is
            guard indexApple != nil else {
                resultAfterReindex.append(row)
                continue
            }
            
            // Get or initialize the counter for this namePart
            let currentIndex = indexCounters[nameApple] ?? 0
            // Create the new string with the current index
            row.key_android = "\(nameAndroid).\(currentIndex)"
            row.key_apple = "\(nameApple).\(currentIndex)"
            resultAfterReindex.append(row)
            // Increment the counter for next occurrence
            indexCounters[nameApple] = currentIndex + 1
        }
        
        return resultAfterReindex
    }
    
    func applySyncWithBase(reindexResult lang: [TsvRow], base: [TsvRow]) -> (lang: [TsvRow], delta: [TsvRow]) {
        var resultLang = [TsvRow]()
        var resultDelta = [TsvRow]()
        
        guard  lang.count == base.count else {
            print("""
            applySyncWithBase() row count mismatch
                lang.count \(lang.count)
                base.count \(base.count)\n
            """)
            return ([], [])
        }
        
        for i in 0 ..< lang.count {
            var rowLang = lang[i]
            let rowBase = base[i]
            
            if rowLang.primaryKey() != rowBase.primaryKey() {
                logger.error("""
                    applySyncWithBase() primary key mismatch
                    Language primary key \(rowLang.primaryKey())
                    Baseline primary key \(rowBase.primaryKey())\n
                    """)
            }
            
            if rowLang.lang_value.isEmpty {
                // new entry. update the row
                rowLang.base_value = rowBase.base_value
                rowLang.lang_value = rowBase.lang_value
                rowLang.base_note = rowBase.base_note
                resultLang.append(rowLang)
                resultDelta.append(rowLang)
            } else if rowLang.base_value != rowBase.base_value {
                // update just the `English_US` `base_value`
                rowLang.base_value = rowBase.base_value
                resultLang.append(rowLang)
                resultDelta.append(rowLang)
            } else {
                resultLang.append(rowLang)
            }
        }
        
        return (resultLang, resultDelta)
    }
    
    func writeTsv(_ tsvRows: [TsvRow], filename: String) {
        guard let cacheDir = outputCacheLocalDir
        else {
            logger.error("outputCacheLocalDir not provided")
            return
        }
        let sheet = TsvSheet(tsvRows: tsvRows)
        let url = cacheDir.appending(path: "\(langStr)_\(filename).tsv", directoryHint: .notDirectory)
        sheet.writeTsvFile(url)
    }

}
