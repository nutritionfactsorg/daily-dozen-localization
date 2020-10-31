//
//  DozeDetailsTsvMainRecord.swift
//  AppLocalizerLib
//

import Foundation


struct DozeDetailsTsvMainRecord {
    /// "key"
    var key_droid: String = ""       
    var key_apple: String = ""
    /// "key.value" Heading <string name="other_fruits">Other Fruits</string>
    var base_value: String = ""          // Base Language (en) English
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
        } else if columns.count != 8 {
            fatalError("TweakDetailsTsvRecord setValues \(columns.count)!=8 \(columns)")
        }
        
        /// "key"
        self.key_droid = columns[0]
        self.key_apple = columns[1]
        /// "key.value" Heading
        self.base_value = columns[2]
        self.lang_value_droid = columns[3]
        self.lang_value_apple = columns[4]
        /// website URL for video TOPIC_ITEM
        self.base_topic = columns[5]
        self.lang_topic_droid = columns[6]
        self.lang_topic_apple = columns[7]
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
        \(key_droid)\t\
        \(key_apple)\t\
        \(base_value)\t\
        \(lang_value_droid)\t\
        
        """
    }
    
    public static func toStringTsvHeader_WAS() -> String { // :!!!!:WAS:
        return """
        key_droid\t\
        key_apple\t\
        base_value\t\
        lang_value_droid\t\
        lang_value_apple\t\
        base_topic\t\
        lang_topic_droid\t\
        lang_topic_apple
        """
    }
    
    public func toStringTsv_WAS() -> String { // :!!!!:WAS:
        return """
        \(key_droid)\t\
        \(key_apple)\t\
        \(base_value)\t\
        \(lang_value_droid)\t\
        \(lang_value_apple)\t\
        \(base_topic)\t\
        \(lang_topic_droid)\t\
        \(lang_topic_apple)
        """
    }
}
