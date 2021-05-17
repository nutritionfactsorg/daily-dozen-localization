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
        
        replaceDict["labelMorning xCp-N8-5Uc.text"] = "weight_entry_morning"
        replaceDict["labelEvening 77g-xa-ali.text"] = "weight_entry_evening"
        replaceDict["labelAmTime FBJ-Im-BZk.text"] = "weight_entry_time"
        replaceDict["labelPmTime g3G-kp-d2S.text"] = "weight_entry_time"

        // button
        replaceDict["clearWeightAMButton 7l0-os-Oqt.normalTitle"] = "weight_entry_clear"
        replaceDict["clearWeightPMButton NRG-eE-YhG.normalTitle"] = "weight_entry_clear"

        // History
        replaceDict["27q-rq-qbu.text"] = "history_scale_label" // android: time_scale
        replaceDict["XdW-g4-ZUO.text"] = "history_scale_label"
        replaceDict["v2E-Ao-OVz.text"] = "history_scale_label"
        replaceDict["sM6-A9-KeP.segmentTitles[0]"] = "history_scale_choice_day"   // android: servings_time_scale_choices.0
        replaceDict["vXy-0q-Ind.segmentTitles[0]"] = "history_scale_choice_day"
        replaceDict["fcu-ZA-byN.segmentTitles[0]"] = "history_scale_choice_day"
        replaceDict["sM6-A9-KeP.segmentTitles[1]"] = "history_scale_choice_month" // servings_time_scale_choices.1
        replaceDict["vXy-0q-Ind.segmentTitles[1]"] = "history_scale_choice_month"
        replaceDict["fcu-ZA-byN.segmentTitles[1]"] = "history_scale_choice_month"
        replaceDict["sM6-A9-KeP.segmentTitles[2]"] = "history_scale_choice_year"  // servings_time_scale_choices.2
        replaceDict["vXy-0q-Ind.segmentTitles[2]"] = "history_scale_choice_year"
        replaceDict["fcu-ZA-byN.segmentTitles[2]"] = "history_scale_choice_year"
        replaceDict["XYD-fX-adn.normalTitle"] = "weight_history_edit_data"        // android: n/a

        // History, Item
        replaceDict["S0Q-oB-VgE.text"] = "item_history_completed_all"  // android: servings_all
        replaceDict["jBv-4d-ofX.text"] = "item_history_completed_some" // android: servings_some
        replaceDict["sLd-Kq-bLv.text"] = "item_history_heading"        // android: history

        // Settings
        replaceDict["OZO-Xa-v5G.segmentTitles[0]"] = "setting_doze_only_choice"  // Android: daily_dozen_only
        replaceDict["OZO-Xa-v5G.segmentTitles[1]"] = "setting_doze_tweak_choice" // Android: daily_dozen_and_tweaks
        replaceDict["WdR-XV-IyP.footerTitle"] = "setting_doze_tweak_footer"      // Android: n/a
        replaceDict["IFs-g0-SPV.footerTitle"] = "settings_units_choice_footer"   // Android: TBD
        replaceDict["Ebp-Lw-fWk.normalTitle"] = "settings_advanced_utilities"    // Android: n/a?

        // Settings, First Launch
        replaceDict["atR-un-jgX.text"] = "setting_health_alone_txt"      // Android: for_health_alone
        replaceDict["OdG-YQ-lT8.text"] = "setting_health_weight_txt"     // Android: for_health_and_weight_loss
        replaceDict["ReM-AP-Fpp.normalTitle"] = "setting_doze_only_btn"  // Android: daily_dozen_only
        replaceDict["Lef-Iw-Ywr.normalTitle"] = "setting_doze_tweak_btn" // Android: daily_dozen_and_tweaks

        // About Menu
        replaceDict["qGY-wh-1gB.text"] = "info_app_about"                    // Android: still need to lookup!!
        replaceDict["zQy-Dn-WXM.text"] = "info_book_how_not_to_die"
        replaceDict["Cxo-5D-YUZ.text"] = "info_book_how_not_to_die_cookbook"
        replaceDict["MWr-7S-G8N.text"] = "info_book_how_not_to_diet"
        replaceDict["beF-Xl-TAq.text"] = "info_webpage_daily_dozen_challenge"
        replaceDict["mqA-Vp-LZ7.text"] = "info_webpage_donate"
        replaceDict["qVR-SQ-jmS.text"] = "info_webpage_open_source"
        replaceDict["dRO-1W-3EK.text"] = "info_webpage_subscribe"
        replaceDict["uxH-8I-ydF.text"] = "info_webpage_videos_latest"

        // Detail Page
        replaceDict["eU6-je-hVN.text"] = "doze_detail_section_sizes"        // ** double use Android: servings_sizes
        replaceDict["YVI-sV-TDX.text"] = "doze_detail_section_types"        // ** double use Android: types
        replaceDict["3bd-8h-kcX.text"] = "units_label"                      // Android: units
        replaceDict["kho-9G-OWe.text"] = "units_label"                      // Android: units
        replaceDict["YVI-sV-TDA.text"] = "tweak_detail_section_activity"    // Android: n/a
        replaceDict["YVI-sV-TDD.text"] = "tweak_detail_section_description" // Android: n/a

        // History
        replaceDict["27q-rq-qbu.text"] = "history_scale_label" // android: time_scale
        replaceDict["XdW-g4-ZUO.text"] = "history_scale_label"
        replaceDict["v2E-Ao-OVz.text"] = "history_scale_label"

        replaceDict["sM6-A9-KeP.segmentTitles[0]"] = "history_scale_choice_day" // android: servings_time_scale_choices.0
        replaceDict["vXy-0q-Ind.segmentTitles[0]"] = "history_scale_choice_day"
        replaceDict["fcu-ZA-byN.segmentTitles[0]"] = "history_scale_choice_day"
        replaceDict["sM6-A9-KeP.segmentTitles[1]"] = "history_scale_choice_month" // servings_time_scale_choices.1
        replaceDict["vXy-0q-Ind.segmentTitles[1]"] = "history_scale_choice_month"
        replaceDict["fcu-ZA-byN.segmentTitles[1]"] = "history_scale_choice_month"
        replaceDict["sM6-A9-KeP.segmentTitles[2]"] = "history_scale_choice_year" // servings_time_scale_choices.2
        replaceDict["vXy-0q-Ind.segmentTitles[2]"] = "history_scale_choice_year"
        replaceDict["fcu-ZA-byN.segmentTitles[2]"] = "history_scale_choice_year"
        replaceDict["XYD-fX-adn.normalTitle"] = "weight_history_edit_data" // android: n/a

        // Weight
        replaceDict["xCp-N8-5Uc.text"] = "weight_entry_morning"       // android: n/a
        replaceDict["77g-xa-ali.text"] = "weight_entry_evening"       // android: n/a
        replaceDict["FBJ-Im-BZk.text"] = "weight_entry_time"          // android: n/a
        replaceDict["g3G-kp-d2S.text"] = "weight_entry_time"          // android: n/a
        replaceDict["7l0-os-Oqt.normalTitle"] = "weight_entry_clear"  // android: n/a
        replaceDict["NRG-eE-YhG.normalTitle"] = "weight_entry_clear"  // android: n/a

        replaceDict["weightEntry.kilograms"] = "weight_entry_units_kg"
        replaceDict["weightEntry.pounds"] = "weight_entry_units_lbs"
        replaceDict["weightEntry.text.kg"] = "weight_entry_units_kg"
        replaceDict["weightEntry.text.lbs"] = "weight_entry_units_lbs"

        // Info Menu
        replaceDict["19L-gq-W5M.text"] = "info_app_about_welcome"
        replaceDict["DJR-bj-qUq.text"] = "info_app_about_app_name"
        replaceDict["dwQ-CS-gz3.text"] = "info_app_about_overview"
        replaceDict["gX5-vX-xBe.text"] = "info_app_about_version"
        replaceDict["pUm-f4-zm1.text"] = "info_app_about_oss_credits"
        replaceDict["Zgt-w4-qQw.text"] = "info_app_about_created_by"
    }
    
    func isDropped(_ key: String) -> Bool {
        return dropSet.contains(key)
    }
    
    func isReplaced(_ key: String) -> String? {
        return replaceDict[key]
    }
    
}
