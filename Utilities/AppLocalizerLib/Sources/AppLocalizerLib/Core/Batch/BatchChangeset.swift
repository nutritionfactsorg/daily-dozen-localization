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
    struct DeltaChangesetRecord {
        let data: [TsvRow]
        let language: String
    }
    var deltaChangesetList: [DeltaChangesetRecord] = []
    
    mutating func addBaseTsvSheet(_ sheet: TsvSheet) {
        writeTsv(sheet.tsvRowList.data, cacheFilename: "90_baseDataAsis")
        let tsvRowList = sheet.tsvRowList.sortedBy1Apple2Droid()
        writeTsv(tsvRowList.data, cacheFilename: "91_basePrimaryKeySorted")
        let tsvReindex = applyReindex(resultAfterInsert: tsvRowList.data)
        writeTsv(tsvReindex, cacheFilename: "92_baseReindexed")
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
        let inputSheet: TsvSheet =  TsvSheet(inputUrl)
        writeTsv(inputSheet.tsvRowList.data, cacheFilename: "01_inputSheet")
        
        // --- SORT --- 
        // TsvSheet sorted sorted and deduplicated via init()
        //deleteSet = deleteSet.sortedByKeyParts()
        //insertSet = insertSet.sortedByKeyParts()
        
        // --- APPLY DELETES `CS_DELETE_KEY`---        
        let resultAfterDelete = applyDeletes(inputRows: inputSheet.tsvRowList.data)
        writeTsv(resultAfterDelete, cacheFilename: "02_afterDelete")
        
        // --- APPLY INSERTS `CS_INSERT_KEY` ---
        // Inserts `\(key_apple):::\(key_android)` key pair without content.
        // Duplicate index until subsequent keys are renumbered.
        let resultAfterInsert = applyInserts(resultAfterDelete: resultAfterDelete)
        writeTsv(resultAfterInsert, cacheFilename: "03_afterInsert")
                
        // --- REINDEX ---
        // Reindexes key numberings
        let resultAfterReindex = applyReindex(resultAfterInsert: resultAfterInsert)
        writeTsv(resultAfterReindex, cacheFilename: "04_afterReindex")
        
        // --- SYNC BASE ---
        // -- 05_baseSheet       All English (base_value == lang_value)
        // -- 06_afterSyncBase   base_value, lang_value == prior value or English
        // -- 07_change          review subset lang_value == prior value or English 
        writeTsv(baseSheet.tsvRowList.data, cacheFilename: "05_baseSheet")
        let resultAfterSyncBase = applySyncWithBase(reindexResult: resultAfterReindex, base: baseSheet.tsvRowList.data)
        writeTsv(resultAfterSyncBase.lang, cacheFilename: "06_afterSyncBase")
        writeTsv(resultAfterSyncBase.change, cacheFilename: "07_change")
        deltaChangesetList.append(
            DeltaChangesetRecord(
                data: resultAfterSyncBase.change,
                language: langStr
            )
        )
        
        // "….toreview.tsv"
        writeTsv(resultAfterSyncBase.lang, url: outputUrl)
        // "….change.tsv"
        let changeUrl = outputUrl
            .deletingPathExtension() // ".tsv"
            .deletingPathExtension() // ".toreview"
            .appendingPathExtension("change.tsv")
        writeTsv(resultAfterSyncBase.change, url: changeUrl)
        
        // Reset for next language
        langInputTsvUrl = nil
        langOutputTsvUrl = nil
    }

    /// `DO_CHANGESET_WRITE_MULTI_TSV`
    func doChangesetWriteMulti(toUrl: URL) {
        var s = "language\tdone\t\(TsvRow.toTsvHeader())"
        for d in deltaChangesetList {
            for r in d.data {
                let tsv = "\(d.language)\tno\t\(r.toTsv())"
                s.append(tsv)
            }
        }
        try? s.write(to: toUrl, atomically: true, encoding: .utf8)
        if let outputCacheLocalDir {
            let cacheUrl = outputCacheLocalDir.appending(component: toUrl.lastPathComponent, directoryHint: .notDirectory)
            try? s.write(to: cacheUrl, atomically: true, encoding: .utf8)
        }
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
        
        guard insertList.isEmpty == false else {
            print("applyInserts() none to apply")
            return resultAfterDelete
        }
        
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
    ///     - any mismatching `key_android` and `key_apple` indices are logged.
    func applyReindex(resultAfterInsert tsvRowList: [TsvRow]) -> [TsvRow] {
        // Dictionary to track the next index for each namePart
        var idxCountersApple: [String: Int] = [:] // [counterKey: count]
        var idxCountersDroid: [String: Int] = [:] // [counterKey: count]
        // Result
        var resultAfterReindex = [TsvRow]()
        
        for var row in tsvRowList {
            let (nameApple, indexApple) = row.key_apple.keyParts()
            let (nameDroid, indexDroid) = row.key_android.keyParts()
            
            if nameDroid == "servings_time_scale_choices" {
                print("DEBUG: found servings_time_scale_choices")
            }
            
            // Neither have index parts, keep the tsv row string as-is
            if indexApple == nil && indexDroid == nil {
                resultAfterReindex.append(row)
                continue
            }
            // Both have index parts
            if indexApple != nil, indexDroid != nil {
                // Get or initialize the counter for this namePart
                let currentIdxApple = idxCountersApple[nameApple] ?? 0
                let currentIdxDroid = idxCountersDroid[nameDroid] ?? 0
                // Create the new string with the current index
                row.key_apple = "\(nameApple).\(currentIdxApple)"                
                row.key_android = "\(nameDroid).\(currentIdxDroid)"
                resultAfterReindex.append(row)
                // Increment the counter for next occurrence
                idxCountersApple[nameApple] = currentIdxApple + 1
                idxCountersDroid[nameDroid] = currentIdxDroid + 1
            } else if indexApple != nil { // Only Apple is indexed
                let currentIdxApple = idxCountersApple[nameApple] ?? 0
                row.key_apple = "\(nameApple).\(currentIdxApple)"                
                resultAfterReindex.append(row)
                idxCountersApple[nameApple] = currentIdxApple + 1
            } else { // indexAndroid != nil. Only Droid is indexed
                let currentIdxDroid = idxCountersDroid[nameDroid] ?? 0
                row.key_android = "\(nameDroid).\(currentIdxDroid)"
                resultAfterReindex.append(row)
                idxCountersDroid[nameDroid] = currentIdxDroid + 1
            }            
        }
        
        return resultAfterReindex
    }
    
    func applySyncWithBase(reindexResult lang: [TsvRow], base: [TsvRow]) -> (lang: [TsvRow], change: [TsvRow]) {
        print("Sync Processing: \(langStr), base: \(base.count), lang: \(lang.count)")
        var resultLang = [TsvRow]()
        var resultDelta = [TsvRow]()
        
        var baseIdx = 0
        var langIdx = 0
        while baseIdx < base.count && langIdx < lang.count {
            let rowBase = base[baseIdx]
            var rowLang = lang[langIdx]
            
            let comparison = rowBase.compare(to: rowLang)
            switch comparison {
            case .lessThan: 
                // base has item to insert as-is (add to lang)
                resultLang.append(rowBase)
                resultDelta.append(rowBase)
                print("    WARNING: inserted base \(rowBase.primaryKey())")
                baseIdx += 1
                
            case .greaterThan: 
                // lang has item to skip (aka delete, not retain)
                print("    WARNING: skipped lang \(rowLang.primaryKey())")
                langIdx += 1
                
            case .equalTo: //
                if rowBase.base_value.trimmingCharacters(in: .whitespaces).isEmpty && 
                    rowBase.lang_value.trimmingCharacters(in: .whitespaces).isEmpty {
                    // blank line. keep as-is. not part of delta.
                    resultLang.append(rowLang)
                } else if rowLang.lang_value.isEmpty {
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
                baseIdx += 1
                langIdx += 1
            }
        }
        
        print("    resultLang: \(resultLang.count), resultDelta: \(resultDelta.count)")
        return (resultLang, resultDelta)
    }
    
    func writeTsv(_ tsvRows: [TsvRow], cacheFilename: String) {
        guard let cacheDir = outputCacheLocalDir
        else {
            logger.error("outputCacheLocalDir not provided")
            return
        }
        let sheet = TsvSheet(tsvRows: tsvRows)
        let url = cacheDir.appending(path: "\(langStr)_\(cacheFilename).tsv", directoryHint: .notDirectory)
        sheet.writeTsvFile(url)
    }

    func writeTsv(_ tsvRows: [TsvRow], url: URL) {
        let sheet = TsvSheet(tsvRows: tsvRows)
        sheet.writeTsvFile(url)
    }

}
