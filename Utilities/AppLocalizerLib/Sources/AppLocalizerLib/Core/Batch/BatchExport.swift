//
//  BatchExport.swift
//  AppLocalizerLib
//

import Foundation

struct BatchExport {
    static var shared = BatchExport()
    //
    enum KeyType {
        case apple
        case droid
        // case paired // "key_droid+key_apple"  
    }
    // 
    var resultsUrl: URL!
    
    mutating func doExport(
        outputLangTsv: URL,
        sourceEnUSTsv: URL?,
        sourceEnUSDroid: URL?,
        sourceLangDroid: URL?,
        sourceEnUSApple: URL?,
        sourceLangApple: URL?
    ) {        
        print("""
        ### DO_EXPORT_TSV doExport() ###
              outputLangTsv = \(outputLangTsv.absoluteString)
              sourceEnUSTsv = \(sourceEnUSTsv?.absoluteString ?? "nil")
            sourceEnUSDroid = \(sourceEnUSDroid?.absoluteString ?? "nil")
            sourceLangDroid = \(sourceLangDroid?.absoluteString ?? "nil")
            sourceEnUSApple = \(sourceEnUSApple?.absoluteString ?? "nil")
            sourceLangApple = \(sourceLangApple?.absoluteString ?? "nil")
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
        var outputLangSheet = TsvSheet(urlList: [outputLangTsv])
        let filename_01 = "01_Export_Output_\(outputLangTsv.lastPathComponent)"
        let url_01 = resultsUrl.appendingPathComponent(filename_01, isDirectory: false)
        outputLangSheet.writeTsvFile(url: url_01, recordList: outputLangSheet.recordListAll)
        
        if let sourceEnUSTsv = sourceEnUSTsv {
            //01_Export_TSV_enUS.tsv
            //    remapped/patched/sorted
            var sourceEnUSSheet = TsvSheet(urlList: [sourceEnUSTsv])
            let filename_02 = "02_Export_TSV_enUS_\(sourceEnUSTsv.lastPathComponent)"
            let url_02 = resultsUrl.appendingPathComponent(filename_02, isDirectory: false)
            sourceEnUSSheet.writeTsvFile(url: url_02, recordList: sourceEnUSSheet.recordListAll)
            
            
            //02_Diff_TSV_enUS.tsv

            //03_Merge_TSV_enUS.tsv (SOURCE base_* onto OUTPUT base_*)

        }


        if let sourceEnUSDroid = sourceEnUSDroid {
            //11_Export_Droid_enUS.tsv

            //12_Diff_Droid_enUS.tsv

            //13_Merge_Droid_enUS.tsv  (SOURCE  ∆key, base_* onto OUTPUT)
        }

        if let sourceLangDroid = sourceLangDroid,
           let sourceLangDroidXmlDoc = try? XMLDocument(contentsOf: sourceLangDroid, options: [.nodePreserveAll, .nodePreserveWhitespace])
           {
            //21_Export_Droid_pl.tsv
            var processor = XmlProcessor(lookupTable: outputLangSheet.getLookupDictAndroid())
            //processor.process(droidXmlUrl: sourceLangDroid, droidXmlDocument: sourceLangDroidXmlDoc)

            //22_Diff_Droid_pl.tsv

            //23_Merge_Droid_pl.tsv    (SOURCE ∆key, base_*, lang_* onto OUTPUT)
        }

        if let sourceEnUSApple = sourceEnUSApple {
            //31_Export_Apple_enUS.tsv

            //32_Diff_Apple_enUS.tsv

            //33_Merge_Apple_enUS.tsv  (SOURCE  ∆key, base_* onto OUTPUT)
        }



        if let sourceLangApple = sourceLangApple {
            //41_Export_Apple_pl.tsv

            //42_Diff_Apple_pl.tsv

            //43_Merge_Apple_pl.tsv    (SOURCE ∆key, base_*, lang_* onto OUTPUT)
        }
        
        print(":FINISHED: BatchExport doExport")
    }
    
    func diff(_ aa: TsvSheet, _ bb: TsvSheet, keyType: KeyType ) -> [TsvRow] {
        //    // add/drop delta
        //    aKeySet.subtracting(bKeySet) // Apple & Droid 
        //    bKeySet.subtracting(aKeySet) // Apple & Droid
        //    // modified
        //    // for key_droid:key_apple in aKeySet.intersecting(bKeySet)
        //    aBaseValue[key_droid:key_apple] == bBaseValue[key_droid:key_apple]

        var diffList = [TsvRow]()
        let aaAppleKeySet = aa.getKeySetApple()
        let aaDroidKeySet = aa.getKeySetAndroid()
        diffList.append(TsvRow(key_android: "", key_apple: "", base_value: "", lang_value: "", comments: "Added "))

        diffList.append(TsvRow(key_android: "", key_apple: "", base_value: "", lang_value: "", comments: "Dropped "))

        
        return diffList
    }
    
    func merge(from: TsvSheet, onto: TsvSheet) -> [TsvRow] {
        //    // add SOURCE delta to OUTPUT  // aKeySet.subtracting(bKeySet)
        //    @ missing  key_*, add/report       base_value/lang_value/note
        //    // SOURCE overwrites OUTPUT base_vale
        //    // updates OUTPUT to-include SOURCE base_comment 
        //    @ matching key_*, overwrite/report base_value/base_comment
        let mergeList = [TsvRow]()
        
        return mergeList
    }
    
}
