//
//  BatchExport.swift
//  AppLocalizerLib
//

import Foundation

struct BatchExport {
    static var shared = BatchExport()
    //
    //enum KeyType {
    //    case apple
    //    case droid
    //    // case paired // "key_droid+key_apple"  
    //}
    
    enum MergeMode {
        //case overwriteAll
        case overwriteBaseValue
        case overwriteLangValue
        //case unionAll
        //case accumulateLangOnly
    }
    // 
    var resultsUrl: URL!
    
    mutating func clearAll() {
        resultsUrl = nil
    }
    
    mutating func doExport(
        outputLangTsv: URL,
        sourceEnUSTsv: URL,
        sourceEnUSDroid: URL,
        sourceLangDroid: URL,
        sourceEnUSApple: URL,
        sourceLangApple: URL
    ) {        
        print("""
        ### DO_EXPORT_TSV doExport() ###
              outputLangTsv = \(outputLangTsv.absoluteString)
              sourceEnUSTsv = \(sourceEnUSTsv.absoluteString)
            sourceEnUSDroid = \(sourceEnUSDroid.absoluteString)
            sourceLangDroid = \(sourceLangDroid.absoluteString)
            sourceEnUSApple = \(sourceEnUSApple.absoluteString)
            sourceLangApple = \(sourceLangApple.absoluteString)
        """)
        
        // ** …/tsv/results_yyyyMMddHHmm/
        let datestamp = Date.datestampyyyyMMddHHmm
        resultsUrl = outputLangTsv
            .deletingLastPathComponent() // *.tsv
            .appendingPathComponent("\(datestamp)_results", isDirectory: true)
        let fm = FileManager.default
        //let attributes = [FileAttributeKey: Any]() 
        try? fm.createDirectory(at: resultsUrl, withIntermediateDirectories: true, attributes: nil)
        
        //00_Export_Output_A_Polish_pl.tsv
        //    remapped/patched/sorted
        var outputLangSheet_00 = TsvSheet(urlList: [outputLangTsv])
        let filename_00 = "00_Export_Output_\(outputLangTsv.lastPathComponent)"
        let url_00 = resultsUrl.appendingPathComponent(filename_00, isDirectory: false)
        outputLangSheet_00.writeTsvFile(url: url_00, recordList: outputLangSheet_00.recordListAll)
        
        //01_Export_TSV_enUS.tsv
        //    remapped/patched/sorted
        var sourceEnUSSheet_01 = TsvSheet(urlList: [sourceEnUSTsv])
        let filename_01 = "01_Export_TSV_enUS_\(sourceEnUSTsv.lastPathComponent)"
        let url_01 = resultsUrl.appendingPathComponent(filename_01, isDirectory: false)
        sourceEnUSSheet_01.writeTsvFile(url: url_01, recordList: sourceEnUSSheet_01.recordListAll)
        
        //02_Diff_TSV_enUS.tsv
        
        //03_Merge_TSV_enUS.tsv (SOURCE base_* into OUTPUT base_*)
        
        //----- enUS_DROID -----//
        //11_Export_enUS_Droid.tsv
        let processor_11_enUS_Droid = XmlIntoTsvProcessor(url: sourceEnUSDroid, isBaseLanguage: true)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("11_Export_enUS_Droid.tsv", isDirectory: false),
            tsvRowDict: processor_11_enUS_Droid.tsvRowDict)
        
        
        //12_Diff_Droid_enUS.tsv
        
        //13_Merge_Droid_enUS.tsv  (SOURCE  ∆key, base_* into OUTPUT)

        //----- LANG_DROID -----//        
        //21_Export_Lang_Droid.tsv
        let processor_21_Lang_Droid = XmlIntoTsvProcessor(url: sourceLangDroid, isBaseLanguage: false)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("21_Export_Lang_Droid.tsv", isDirectory: false),
            tsvRowDict: processor_21_Lang_Droid.tsvRowDict)
                
        //22_Diff_Droid_pl.tsv
        
        //23_Merge_Droid_pl.tsv    (SOURCE ∆key, base_*, lang_* into OUTPUT)

        // merge: processor_11_enUS_Droid, processor_21_Lang_Droid
        //        --> merged_11_21_Droid
        let merged_21_11_Droid = merge(
            from: processor_21_Lang_Droid.tsvRowDict, 
            into: processor_11_enUS_Droid.tsvRowDict, 
            mode: .overwriteLangValue)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("21->11_Merge_Droid.tsv", isDirectory: false), 
            tsvRowDict: merged_21_11_Droid)
        
        // diff: merged_11_21_Droid with outputLangSheet
        
        let diffResults = diff(from: merged_21_11_Droid, into: outputLangSheet_00.getDictionaries().droid)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("21->11_Add_Droid.tsv", isDirectory: false), 
            tsvRowDict: diffResults.added)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("21->11_Drop_Droid.tsv", isDirectory: false), 
            tsvRowDict:  diffResults.dropped)

        
        //31_Export_Apple_enUS.tsv
        let processor_31 = XliffIntoTsvProcessor(url: sourceEnUSApple)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("31_Xliff_Apple_enUS.tsv"), 
            tsvRowDict: processor_31.tsvRowDict)
        let processor_32 = JsonIntoTsvProcessor(xliffUrl: sourceEnUSApple, isBaseLanguage: true)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("32_Json_Apple_enUS.tsv"), 
            tsvRowDict: processor_32.tsvRowDict)
        let merge_32_31 = merge(from: processor_32.tsvRowDict, into: processor_31.tsvRowDict, mode: .overwriteBaseValue)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("32->31_XliffJson_Apple_enUS.tsv", isDirectory: false),
            tsvRowDict: merge_32_31)
        
        //32_Diff_Apple_enUS.tsv
        
        //33_Merge_Apple_enUS.tsv  (SOURCE  ∆key, base_* into OUTPUT)
        
        //41_Export_Apple_lang.tsv
        let processor_41 = XliffIntoTsvProcessor(url: sourceLangApple)
        let processor_42 = JsonIntoTsvProcessor(xliffUrl: sourceLangApple, isBaseLanguage: false)
        let merge_42_41 = merge(from: processor_42.tsvRowDict, into: processor_41.tsvRowDict, mode: .overwriteLangValue)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("42->41_XliffJson_Apple_lang.tsv", isDirectory: false),
            tsvRowDict: merge_42_41)
        
        // 
        let diffResults_42_32 = diff(from: merge_42_41, into: merge_32_31)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("43(42->32)_Add_Apple.tsv", isDirectory: false), 
            tsvRowDict: diffResults_42_32.added)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("43(42->32)_Drop_Apple.tsv", isDirectory: false), 
            tsvRowDict:  diffResults_42_32.dropped)
        let merge_42_32 = merge(from: merge_42_41, into: merge_32_31, mode: .overwriteLangValue)
        writeTsvFile(
            url: resultsUrl.appendingPathComponent("43(42->32)_Drop_Apple.tsv", isDirectory: false), 
            tsvRowDict: merge_42_32)

        //42_Diff_Apple_pl.tsv
        
        //43_Merge_Apple_pl.tsv    (SOURCE ∆key, base_*, lang_* into OUTPUT)
        
        //-//-//-//-//-//-//-//-//-//-// 
        
        
        print(":FINISHED: BatchExport doExport")
    }
    
    func diff(from: [String : TsvRow], into: [String : TsvRow]) -> (added: [String : TsvRow], dropped: [String : TsvRow]) {    
        // -- Add/Drop Delta --
        let fromKeySet = Set<String>(from.keys)
        let intoKeySet = Set<String>(into.keys)
        
        // What would "from" add to "into"?
        let addSet = fromKeySet.subtracting(intoKeySet)                
        var addedDict = [String : TsvRow]()
        for key in addSet {
            addedDict[key] = from[key]
        }
        
        // What would "from" have "into" drop?
        let dropSet = intoKeySet.subtracting(fromKeySet)
        var droppedDict = [String : TsvRow]()
        for key in dropSet {
            droppedDict[key] = into[key]
        }
        
        // -- modified
        // for key_droid:key_apple in aKeySet.intersecting(bKeySet)
        // aBaseValue[key_droid:key_apple] == bBaseValue[key_droid:key_apple]
        
        return (addedDict, droppedDict)
    }
    
    func getKeySet(dict: [String : TsvRow]) -> Set<String> {
        return Set<String>(dict.keys)
    }
    
    func merge(from: [String : TsvRow], into: [String : TsvRow], mode: MergeMode) -> [String : TsvRow] {
        //    // add SOURCE delta to OUTPUT  // aKeySet.subtracting(bKeySet)
        //    @ missing  key_*, add/report       base_value/lang_value/note
        //    // SOURCE overwrites OUTPUT base_vale
        //    // updates OUTPUT to-include SOURCE base_comment 
        //    @ matching key_*, overwrite/report base_value/base_comment
        var mergeDict = into
        for fromItem in from {
            if var intoRow = mergeDict[fromItem.key] {
                switch mode {
                case .overwriteBaseValue:
                    intoRow.base_value = fromItem.value.base_value
                    mergeDict[fromItem.key] = intoRow
                case .overwriteLangValue:
                    intoRow.lang_value = fromItem.value.lang_value
                    mergeDict[fromItem.key] = intoRow
                //case .overwriteAll:
                }
            } else {
                switch mode {
                case .overwriteBaseValue:
                    mergeDict[fromItem.key] = fromItem.value
                case .overwriteLangValue:
                    mergeDict[fromItem.key] = fromItem.value
                //case .overwriteAll:
                }
            }
        }
        
        return mergeDict
    }
    
    mutating func writeTsvFile(url: URL, tsvRowDict: [String : TsvRow]) {
        var tsvRowList = Array(tsvRowDict.values)
        tsvRowList = TsvSheet.sortRecordList(tsvRowList)
        var outputString = "key_droid\tkey_apple\tbase_value\tlang_value\tbase_comment\r\n"
        for row in tsvRowList {
            outputString.append(row.toTsv())
        }
        do {
            try outputString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(":ERROR: BatchExport writeTsvFile \(error)")
        }
    }
    
}
