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
        
        // /////////////////////////////////// //
        // TSV: enUS (baseline), LANG (target) //
        // /////////////////////////////////// //        
        // Note: TSV Sheets are remapped, patched and sorted
        let outputLangSheet_00 = TsvSheet(urlList: [outputLangTsv])
        let filename_00 = "00_tsv_output_begin_\(outputLangTsv.lastPathComponent)"
        outputLangSheet_00.writeTsvFile(fullUrl: fileUrl(filename_00))
        
        let sourceEnUSSheet_01 = TsvSheet(urlList: [sourceEnUSTsv])
        let filename_01 = "01_tsv_base_\(sourceEnUSTsv.lastPathComponent)"
        sourceEnUSSheet_01.writeTsvFile(fullUrl: fileUrl(filename_01))
        
        // :NYI: check for key deltas relative to EnglishUS baseline
        // :CHECK: output is exepted to have the same keys and base_lang 

        // //////////////////////// //
        // DROID: XML (enUS + LANG) //
        // //////////////////////// //        
        let p_11_droid_enUS = XmlIntoTsvProcessor(url: sourceEnUSDroid, baseOrLang: .baseMode)
        p_11_droid_enUS.writeTsvFile(fileUrl("11_xml_enUS_droid.tsv"))
        let p_12_droid_lang = XmlIntoTsvProcessor(url: sourceLangDroid, baseOrLang: .langMode)
        p_12_droid_lang.writeTsvFile(fileUrl("12_xml_droid_lang.tsv"))
        let merged_13_droid_both = p_11_droid_enUS.applyingValues(
            from: p_12_droid_lang.tsvRowList, 
            withKeyType: .droid, 
            ofValueType: .lang)
        merged_13_droid_both.writeTsvFile(fileUrl("13_droid_both.tsv"))
        
        // /////////////////////////////// //
        // APPLE: XLIFF+JSON (enUS + LANG) //
        // /////////////////////////////// //
        // APPLE enUS
        let p_21a_xliff_enUS = XliffIntoTsvProcessor(url: sourceEnUSApple)
        //p_21a_xliff_enUS.writeTsvFile(fileUrl("21a_xliff_apple_enUS.tsv"))
        let p_21b_json_enUS = JsonIntoTsvProcessor(xliffUrl: sourceEnUSApple, baseOrLang: .baseMode)
        //p_21b_json_enUS.writeTsvFile(fileUrl("21b_json_apple_enUS.tsv"))
        let merge_21c_apple_enUS = p_21a_xliff_enUS.applyingValues(
            from: p_21b_json_enUS.tsvRowList, 
            withKeyType: .apple, 
            ofValueType: .base)
        merge_21c_apple_enUS.writeTsvFile(fileUrl("21c_apple_enUS.tsv"))
        // APPLE LANG
        let p_22a_xliff_lang = XliffIntoTsvProcessor(url: sourceLangApple)
        let p_22b_json_lang = JsonIntoTsvProcessor(xliffUrl: sourceLangApple, baseOrLang: .langMode)
        let merge_22c_apple_lang = p_22a_xliff_lang.tsvRowList.applyingValues(
            from: p_22b_json_lang.tsvRowList, 
            withKeyType: .apple, 
            ofValueType: .lang)
        merge_22c_apple_lang.writeTsvFile(fileUrl("22c_apple_lang.tsv"))
        // APPLE: BOTH (LANG applied onto enUS)
        let merge_23_apple_both = merge_21c_apple_enUS.applyingValues(from: merge_22c_apple_lang, withKeyType: .apple, ofValueType: .lang)        
        merge_23_apple_both.writeTsvFile(fileUrl("23_apple_both.tsv"))

        // 
        // APPLE: DIFF apple_lang to apple_base
        let diff22_apple_base_lang = merge_22c_apple_lang.diffKeys(merge_21c_apple_enUS, byKeyType: .apple)
        diff22_apple_base_lang.added.writeTsvFile(fileUrl("22c?21c_add_apple.tsv"))
        diff22_apple_base_lang.dropped.writeTsvFile(fileUrl("22c?21c_drop_apple.tsv"))
        
        //43_Merge_Apple_pl.tsv    (SOURCE ∆key, base_*, lang_* into OUTPUT)
        
        //-//-//-//-//-//-//-//-//-//-// 
        
        // diff: merged_23_droid_both with outputLangSheet
        let diff_13_00_droid = outputLangSheet_00.diffKeys(merged_13_droid_both, byKeyType: .droid)
        diff_13_00_droid.added.writeTsvFile(fileUrl("13?00_add_key_droid.tsv"))
        diff_13_00_droid.dropped.writeTsvFile(fileUrl("13?00_drop_key_droid.tsv"))
        
        // --------- MERGE -------------
        
        let merge_Android = outputLangSheet_00
            .applyingValues(
                from: merge_23_apple_both, 
                withKeyType: .apple, 
                ofValueType: .base)
            .applyingValues(
                from: merge_23_apple_both, 
                withKeyType: .apple, 
                ofValueType: .lang)
            .applyingValues(
                from: merged_13_droid_both, 
                withKeyType: .droid, 
                ofValueType: .base)
            .applyingValues(
                from: merged_13_droid_both, 
                withKeyType: .droid, 
                ofValueType: .lang)
        merge_Android.writeTsvFile(fileUrl("Android.tsv"))
        
        let merge_Apple = outputLangSheet_00
            .applyingValues(
                from: merged_13_droid_both, 
                withKeyType: .droid, 
                ofValueType: .base)
            .applyingValues(
                from: merged_13_droid_both, 
                withKeyType: .droid, 
                ofValueType: .lang)
            .applyingValues(
                from: merge_23_apple_both, 
                withKeyType: .apple, 
                ofValueType: .base)
            .applyingValues(
                from: merge_23_apple_both, 
                withKeyType: .apple, 
                ofValueType: .lang)
        merge_Apple.writeTsvFile(fileUrl("Apple.tsv"))
        
        print(":END: BatchExport doExport ... but maybe not finished.")
    }
    
    // MARK: - Utilities
    
    func fileUrl(_ name: String) -> URL {
        return resultsUrl.appendingPathComponent(name, isDirectory: false)
    }
    
}
