//
//  DozeDetailsTsvVarietyRecord.swift
//  AppLocalizerLib
//

import Foundation


struct DozeDetailsTsvVarietyRecord {
    /// "key"
    var key_droid: String = ""       
    var key_apple: String = ""
    /// 1 … N
    var sequence: Int = 0
    /// Variety aka "Type"
    var base_value: String = ""     // Base Language (en) English
    var lang_value_droid: String = ""  // Target Language
    var lang_value_apple: String = ""   // Target Language
    /// website URL for video TOPIC_ITEM
    var base_topic: String = "" 
    var lang_topic_droid: String = "" 
    var lang_topic_apple: String = "" 
    
    init(androidKey: String, iphoneKey: String) {
        self.key_droid = androidKey
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
        self.key_droid = columns[0]
        self.key_apple = columns[1]
        /// 
        self.sequence = Int(columns[2])!
        /// Website URL component for video TOPIC_ITEM
        self.base_topic = columns[3]
        self.lang_topic_droid = columns[4]
        self.lang_topic_apple = columns[5]
        /// Variety aka "Type"
        self.base_value = columns[6]
        self.lang_value_droid = columns[7]
        self.lang_value_apple = columns[8]
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
        return """
        \(key_droid)[\(sequence)]\t\
        \(key_apple)[\(sequence)]\t\
        \(base_value)\t\
        \(lang_value_droid)\t\
          
        """
    }
    
    public static func toStringTsvHeader_WAS() -> String {
        return """
        key_droid\t\
        key_apple\t\
        #\t\
        base_topic\t\
        lang_topic_droid\t\
        lang_topic_apple\t\
        base_value\t\
        lang_value_droid\t\
        lang_value_apple
        """
    }
    
    public func toStringTsv_WAS() -> String {
        return """
        \(key_droid)\t\
        \(key_apple)\t\
        \(sequence)\t\
        \(base_topic)\t\
        \(lang_topic_droid)\t\
        \(lang_topic_apple)\t\
        \(base_value)\t\
        \(lang_value_droid)\t\
        \(lang_value_apple)
        """
    }
}
