//
//  DozeDetailsTsvServingRecord.swift
//  AppLocalizerLib
//

import Foundation


struct DozeDetailsTsvServingRecord {
    /// "key"
    var key_android: String = ""       
    var key_apple: String = ""
    /// 1 … N
    var sequence: Int = 0
    /// 
    var base_imperial: String = ""     // Base Language (en) English
    var lang_imperial_droid: String = ""  // Target Language
    var lang_imperial_apple: String = ""   // Target Language
    /// 
    var base_metric: String = ""     // Base Language (en) English
    var lang_metric_droid: String = ""  // Target Language
    var lang_metric_apple: String = ""   // Target Language
    
    init(androidKey: String, iphoneKey: String) {
        self.key_android = androidKey
        self.key_apple = iphoneKey
    }
    
    mutating func setValues(tsv: String) {
        let columns = tsv.components(separatedBy: "\t")
        
        if tsv.isEmpty { 
            return             
        } else if columns.count == 1 {
            return
        } else if columns.count != 9 {
            fatalError("TweakDetailsTsvRecord setValues \(columns.count)!=9 \(columns)")
        }
        
        /// "key"
        self.key_android = columns[0]
        self.key_apple = columns[1]
        /// 
        self.sequence = Int(columns[2])!
        /// imperial serving size
        self.base_imperial = columns[3]
        self.lang_imperial_droid = columns[4]
        self.lang_imperial_apple = columns[5]
        /// metric serving size
        self.base_metric = columns[6]
        self.lang_metric_droid = columns[7]
        self.lang_metric_apple = columns[8]
    }
    
    public static func toStringTsvHeader() -> String {
        return """
        key_droid\t\
        key_apple\t\
        base_value\t\
        lang_value\t\
        base_comment
        """
    }
    
    public func toStringTsv() -> String {
        var str = """
        \(key_android)[imperial][\(sequence)]\t\
        \(key_apple)[imperial][\(sequence)]\t\
        \(base_imperial)\t\
        \(lang_imperial_droid)\t\
          
        """
        str.append("\n")
        str.append(
            """
            \(key_android)[metric][\(sequence)]\t\
            \(key_apple)[metric][\(sequence)]\t\
            \(base_metric)\t\
            \(lang_metric_droid)\t\
              
            """
        )
        
        return str
    }
    
    public static func toStringTsvHeader_WAS() -> String {
        return """
        key_droid\t\
        key_apple\t\
        #\t\
        base_imperial\t\
        lang_imperial_droid\t\
        lang_imperial_apple\t\
        base_metric\t\
        lang_metric_droid\t\
        lang_metric_apple
        """
    }
    
    public func toStringTsv_WAS() -> String {
        return """
        \(key_android)\t\
        \(key_apple)\t\
        \(sequence)\t\
        \(base_imperial)\t\
        \(lang_imperial_droid)\t\
        \(lang_imperial_apple)\t\
        \(base_metric)\t\
        \(lang_metric_droid)\t\
        \(lang_metric_apple)
        """
    }
}
