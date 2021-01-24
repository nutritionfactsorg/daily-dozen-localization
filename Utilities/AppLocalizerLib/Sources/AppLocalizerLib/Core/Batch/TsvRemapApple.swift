//
//  TsvRemapApple.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvRemapApple {

    static let check = TsvRemapApple()
    // 
    private var dropSet: Set<String>
    private var replaceDict: [String: String]
    
    init() {
        dropSet = Set<String>()
        dropSet.insert("OC8-wt-JgC.normalTitle") // "dateButtonTitle.today"
        dropSet.insert("iHh-5a-01X.normalTitle") // "dateButtonTitle.today"
        dropSet.insert("OIQ-oh-3QN.normalTitle") // "dateBackButtonTitle"
        dropSet.insert("Qfe-bW-SP4.normalTitle") // "dateBackButtonTitle"
        
        // Use key sort order 09AZaz to replace first instance
        // of multi-instance key group
        replaceDict = [String: String]()
        replaceDict["6FY-X2-BdZ.normalTitle"] = "dateButtonTitle.today"
        replaceDict["7XY-Lo-Hwf.normalTitle"] = "dateBackButtonTitle"
        
        // TSV v1 update
        replaceDict["dozeBeans"] = "dozeBeans.heading"
        replaceDict["dozeBerries"] = "dozeBerries.heading"
        replaceDict["dozeFruitsOther"] = "dozeFruitsOther.heading"
        replaceDict["dozeVegetablesCruciferous"] = "dozeVegetablesCruciferous.heading"
        replaceDict["dozeGreens"] = "dozeGreens.heading"
        replaceDict["dozeVegetablesOther"] = "dozeVegetablesOther.heading"
        replaceDict["dozeFlaxseeds"] = "dozeFlaxseeds.heading"
        replaceDict["dozeNuts"] = "dozeNuts.heading"
        replaceDict["dozeSpices"] = "dozeSpices.heading"
        replaceDict["dozeWholeGrains"] = "dozeWholeGrains.heading"
        replaceDict["dozeBeverages"] = "dozeBeverages.heading"
        replaceDict["dozeExercise"] = "dozeExercise.heading"
        replaceDict["otherVitaminB12"] = "otherVitaminB12.heading"
        replaceDict["otherVitaminD"] = "otherVitaminD.heading"
        replaceDict["otherOmega3"] = "otherOmega3.heading"
    }
    
    func isDropped(_ key: String) -> Bool {
        return dropSet.contains(key)
    }
    
    func isReplaced(_ key: String) -> String? {
        return replaceDict[key]
    }
    
}
