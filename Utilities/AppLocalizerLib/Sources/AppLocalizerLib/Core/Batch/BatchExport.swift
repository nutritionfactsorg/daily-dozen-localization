//
//  BatchExport.swift
//  AppLocalizerLib
//

import Foundation

struct BatchExport {
    static var shared = BatchExport()
    
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
        try? fm.createDirectory(at: resultsUrl, withIntermediateDirectories: true, attributes: nil)
        
        //00_Export_Output_A_Polish_pl.tsv
        //    remapped/patched/sorted
        let outputLangSheet_00 = TsvSheet(urlList: [outputLangTsv])
        let filename_00 = "00_Export_Output_\(outputLangTsv.lastPathComponent)"
        outputLangSheet_00.writeTsvFile(fullUrl: fileUrl(filename_00))
        
        //01_Export_TSV_enUS.tsv
        //    remapped/patched/sorted
        let sourceEnUSSheet_01 = TsvSheet(urlList: [sourceEnUSTsv])
        let filename_01 = "01_Export_TSV_enUS_\(sourceEnUSTsv.lastPathComponent)"
        sourceEnUSSheet_01.writeTsvFile(fullUrl: fileUrl(filename_01))
        
        //02_Diff_TSV_enUS.tsv
        
        //03_Merge_TSV_enUS.tsv (SOURCE base_* into OUTPUT base_*)
        
        //----- enUS_DROID -----//
        //11_Export_enUS_Droid.tsv
        let processor_11_enUS_Droid = XmlIntoTsvProcessor(url: sourceEnUSDroid, isBaseLanguage: true)
        processor_11_enUS_Droid.writeTsvFile(fileUrl("11_Export_enUS_Droid.tsv"))
                
        //12_Diff_Droid_enUS.tsv
        
        //13_Merge_Droid_enUS.tsv  (SOURCE  ∆key, base_* into OUTPUT)

        //----- LANG_DROID -----//        
        //21_Export_Lang_Droid.tsv
        let processor_21_Lang_Droid = XmlIntoTsvProcessor(url: sourceLangDroid, isBaseLanguage: false)
        processor_21_Lang_Droid.writeTsvFile(fileUrl("21_Export_Lang_Droid.tsv"))
                
        //22_Diff_Droid_pl.tsv
        
        //23_Merge_Droid_pl.tsv    (SOURCE ∆key, base_*, lang_* into OUTPUT)

        // merge: processor_11_enUS_Droid, processor_21_Lang_Droid
        //        --> merged_11_21_Droid
        let merged_21_11_Droid = processor_11_enUS_Droid.applyingValues(
            from: processor_21_Lang_Droid.tsvRowList, 
            withKeyType: .droid, 
            ofValueType: .lang)
        merged_21_11_Droid.writeTsvFile(fileUrl("21->11_Merge_Droid.tsv"))
        
        // diff: merged_11_21_Droid with outputLangSheet
        let diffResults = outputLangSheet_00.diffKeys(merged_21_11_Droid, byKeyType: .droid)
        diffResults.added.writeTsvFile(fileUrl("21->11_Add_Droid.tsv"))
        diffResults.dropped.writeTsvFile(fileUrl("21->11_Drop_Droid.tsv"))
        
        //31_Export_Apple_enUS.tsv
        let processor_31 = XliffIntoTsvProcessor(url: sourceEnUSApple)
        processor_31.writeTsvFile(fileUrl("31_Xliff_Apple_enUS.tsv"))

        let processor_32 = JsonIntoTsvProcessor(xliffUrl: sourceEnUSApple, isBaseLanguage: true)
        processor_32.writeTsvFile(fileUrl("32_Json_Apple_enUS.tsv"))
        
        let merge_32_31 = processor_31.applyingValues(
            from: processor_32.tsvRowList, 
            withKeyType: .apple, 
            ofValueType: .base)
        merged_21_11_Droid.writeTsvFile(fileUrl("32->31_XliffJson_Apple_enUS.tsv"))
        
        //32_Diff_Apple_enUS.tsv
        
        //33_Merge_Apple_enUS.tsv  (SOURCE  ∆key, base_* into OUTPUT)
        
        //41_Export_Apple_lang.tsv
        let processor_41 = XliffIntoTsvProcessor(url: sourceLangApple)
        let processor_42 = JsonIntoTsvProcessor(xliffUrl: sourceLangApple, isBaseLanguage: false)
        let merge_42_41 = processor_41.tsvRowList.applyingValues(
            from: processor_42.tsvRowList, 
            withKeyType: .apple, 
            ofValueType: .lang)
        
        merge_42_41.writeTsvFile(fileUrl("42->41_XliffJson_Apple_lang.tsv"))
        
        // 
        let diffResults_42_32 = merge_32_31.diffKeys(merge_42_41, byKeyType: .apple)
        diffResults_42_32.added.writeTsvFile(fileUrl("43(42->32)_Add_Apple.tsv"))
        diffResults_42_32.dropped.writeTsvFile(fileUrl("43(42->32)_Drop_Apple.tsv"))
        
        let merge_42_32 = merge_32_31.applyingValues(from: merge_42_41, withKeyType: .apple, ofValueType: .lang)        
        merge_42_32.writeTsvFile(fileUrl("43(42->32)_Drop_Apple.tsv"))

        //42_Diff_Apple_pl.tsv
        
        //43_Merge_Apple_pl.tsv    (SOURCE ∆key, base_*, lang_* into OUTPUT)
        
        //-//-//-//-//-//-//-//-//-//-// 
        
        
        print(":FINISHED: BatchExport doExport")
    }
    
    // MARK: - Utilities
    
    func fileUrl(_ name: String) -> URL {
        return resultsUrl.appendingPathComponent(name, isDirectory: false)
    }
    
}
