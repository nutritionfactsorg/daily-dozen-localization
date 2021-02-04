//
//  LanguageCodes.swift
//  AppLocalizerLib
//

import Foundation

struct LanguageCodes {
    
    // :NYI: consider double underline for non-regionalized language prefixes
    // For example `Spanish__es` vs. `Spanish_Mexico_es-MX`
    
    var filePrefixToCodes: [String: (apple: String, droid: String)] 
    
    init() {
        filePrefixToCodes = [String: (apple: String, droid: String)]()
        filePrefixToCodes["English_US"] = (apple: "en_US", droid: "en-US")
        filePrefixToCodes["Spanish_"] = ("es", "es")
    }
    
    func getAndroidCode(filePrefix: String) -> String? {
        return filePrefixToCodes[filePrefix]?.0
    }
    
}
