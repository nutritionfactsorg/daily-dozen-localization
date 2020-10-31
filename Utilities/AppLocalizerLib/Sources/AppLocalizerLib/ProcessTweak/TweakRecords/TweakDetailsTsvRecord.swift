//
//  TweakDetailsTsvRecord.swift
//  AppLocalizerLib
//

import Foundation

struct TweakDetailsTsvRecord {
    /// "key"
    var key_droid: String = ""       
    var key_apple: String = ""
    /// :???:NYI: currently no website URL for video TOPIC_ITEM
    var base_topic: String = "" 
    var lang_topic_droid: String = "" 
    var lang_topic_apple: String = "" 
    /// "key.value" Heading
    var base_value_heading: String = ""
    var lang_value_heading_droid: String = ""
    var lang_value_heading_apple: String = ""
    /// "key.value_short.value" Activity
    var base_value_short: String = ""
    var lang_value_short_droid: String = ""
    var lang_value_short_apple_imperial: String = ""
    var lang_value_short_apple_metric: String = ""
    // "key.value_text" Description
    var base_value_text: String = "" 
    var lang_value_text_droid: String = ""
    var lang_value_text_apple: String = ""
    
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
        } else if columns.count != 15 {
            fatalError("TweakDetailsTsvRecord setValues \(columns.count)!=15 \(columns)")
        }
        
        /// "key"
        self.key_droid = columns[0]
        self.key_apple = columns[1]
        /// :???:NYI: currently no website URL for video TOPIC_ITEM
        self.base_topic = columns[2]
        self.lang_topic_droid = columns[3]
        self.lang_topic_apple = columns[4]
        /// "key.value" Heading
        self.base_value_heading = columns[5]
        self.lang_value_heading_droid = columns[6]
        self.lang_value_heading_apple = columns[7]
        /// "key.value_short.value" Activity
        self.base_value_short = columns[8]
        self.lang_value_short_droid = columns[9]
        self.lang_value_short_apple_imperial = columns[10]
        self.lang_value_short_apple_metric = columns[11]
        // "key.value_text" Description
        self.base_value_text = columns[12]
        self.lang_value_text_droid = columns[13]
        self.lang_value_text_apple = columns[14]
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
        var str = ""
        
        str.append(
            """
            \(key_droid)[heading]\t\
            \(key_apple)[heading]\t\
            \(base_value_heading)\t\
            \(lang_value_heading_droid)\t\
            \n
            """
        )
        str.append(
            """
            \(key_droid)[short]\t\
            \(key_apple)[short]\t\
            \(base_value_short)\t\
            \(lang_value_short_droid)\t\
            \n
            """
        )
        str.append(
            """
            \(key_droid)[text]\t\
            \(key_apple)[text]\t\
            \(base_value_text)\t\
            \(lang_value_text_droid)\t\
            \n
            """
        )
        
        return str
    }
    
    public static func toStringTsvHeader_WAS() -> String {
        return """
        key_droid\t\
        key_apple\t\
        base_topic\t\
        lang_topic_droid\t\
        lang_topic_apple\t\
        base_value\t\
        lang_value_droid\t\
        lang_value_apple\t\
        base_value_short\t\
        lang_value_short_droid\t\
        lang_value_short_apple_imperial\t\
        lang_value_short_apple_metric\t\
        base_value\t\
        lang_value_droid\t\
        lang_value_apple
        """
    }
    
    public func toStringTsv_WAS() -> String {
        return """
        \(key_droid)\t\
        \(key_apple)\t\
        \(base_topic)\t\
        \(lang_topic_droid)\t\
        \(lang_topic_apple)\t\
        \(base_value_heading)\t\
        \(lang_value_heading_droid)\t\
        \(lang_value_heading_apple)\t\
        \(base_value_short)\t\
        \(lang_value_short_droid)\t\
        \(lang_value_short_apple_imperial)\t\
        \(lang_value_short_apple_metric)\t\
        \(base_value_text)\t\
        \(lang_value_text_droid)\t\
        \(lang_value_text_apple)
        """
    }
}
