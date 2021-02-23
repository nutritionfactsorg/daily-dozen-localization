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
        dropSet.insert("dailyReminder.subtitle") // not used
        
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

        // "Daily Reminder" Alert title. Settings section heading
        replaceDict["dailyReminder.title"] = "reminder.heading"
        replaceDict["GiY-ao-2ee.headerTitle"] = "reminder.heading" 
        // 
        replaceDict["dailyReminder.text"] = "reminder.alert.text"
        
        replaceDict["pjz-An-Ls5.text"] = "reminder.settings.enable"
        replaceDict["itH-G7-Kal.text"] = "reminder.settings.enable"
        
        replaceDict["kR3-Sa-Fpt.text"] = "reminder.settings.time"
        replaceDict["YP6-dP-Y62.text"] = "reminder.settings.sound"
        replaceDict["XFw-2q-BdT.text"] = "reminder.state.on"
        
        replaceDict["IFs-g0-SPV.headerTitle"] = "settings.units.header"
        replaceDict["WdR-XV-IyP.headerTitle"] = "settings.tweak.header"
        
    }
    
    func isDropped(_ key: String) -> Bool {
        return dropSet.contains(key)
    }
    
    func isReplaced(_ key: String) -> String? {
        return replaceDict[key]
    }
    
}
