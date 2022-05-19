//
//  TsvRemapApple.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvRemapApple {

    static let check = TsvRemapApple()
    /// given key as `key_apple`, then delete tsv row 
    private var dropSet: Set<String>
    /// given key as `key_apple`, then apply value to update `key_apple`for tsv row
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

        // Entry
        replaceDict["1HM-mL-ZV9.text"] = "doze_entry_header"        // Android: servings
                
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
        replaceDict["DJR-bj-qUq.text"] = "info_app_about_app_name"    // apple.info.about.2
        replaceDict["Zgt-w4-qQw.text"] = "info_app_about_created_by"  // apple.info.about.4
        replaceDict["pUm-f4-zm1.text"] = "info_app_about_oss_credits" // apple.info.about.5
        replaceDict["dwQ-CS-gz3.text"] = "info_app_about_overview"    // apple.info.about.1
        replaceDict["gX5-vX-xBe.text"] = "info_app_about_version"     // apple.info.about.3
        replaceDict["19L-gq-W5M.text"] = "info_app_about_welcome"     // apple.info.about.0

        replaceDict["apple.info.about.0"] = "info_app_about_welcome"
        replaceDict["apple.info.about.1"] = "info_app_about_overview"
        replaceDict["apple.info.about.2"] = "info_app_about_app_name"
        replaceDict["apple.info.about.3"] = "info_app_about_version"
        replaceDict["apple.info.about.4"] = "info_app_about_created_by"
        replaceDict["apple.info.about.5"] = "info_app_about_oss_credits"
        replaceDict["info.about.title"]   = "info_app_about_heading"
        
        // Settings
        replaceDict["OZO-Xa-v5G.segmentTitles[0]"] = "setting_doze_only_choice"  // Android: daily_dozen_only
        replaceDict["OZO-Xa-v5G.segmentTitles[1]"] = "setting_doze_tweak_choice" // Android: daily_dozen_and_tweaks
        replaceDict["WdR-XV-IyP.footerTitle"] = "setting_doze_tweak_footer"      // Android: n/a
        replaceDict["WdR-XV-IyP.headerTitle"] = "setting_tweak_header"
        replaceDict["settings.tweak.header"]  = "setting_tweak_header"  // Android: 

        replaceDict["IFs-g0-SPV.headerTitle"] = "setting_units_header"
        replaceDict["settings.units.header"]  = "setting_units_header"  // Android: TBD
        
        replaceDict["IFs-g0-SPV.footerTitle"] = "setting_units_choice_footer"   // Android: TBD
        replaceDict["settings_units_choice_footer"] = "setting_units_choice_footer" // Android: TBD
        
        // Android:NYI: user setting of imperial, metric or toggle units
        replaceDict["RLb-GV-4hh.segmentTitles[0]"] = "setting_units_0_imperial" 
        replaceDict["RLb-GV-4hh.segmentTitles[1]"] = "setting_units_1_metric"
        replaceDict["RLb-GV-4hh.segmentTitles[2]"] = "setting_units_2_toggle"
        replaceDict["settings_units_0_imperial"] = "setting_units_0_imperial" 
        replaceDict["settings_units_1_metric"]   = "setting_units_1_metric"
        replaceDict["settings_units_2_toggle"]   = "setting_units_2_toggle"

        // Settings, First Launch
        replaceDict["atR-un-jgX.text"] = "setting_health_alone_txt"      // Android: for_health_alone
        replaceDict["OdG-YQ-lT8.text"] = "setting_health_weight_txt"     // Android: for_health_and_weight_loss
        replaceDict["daily_dozen_only"] = "setting_doze_only_btn"
        replaceDict["ReM-AP-Fpp.normalTitle"] = "setting_doze_only_btn"  // Android: daily_dozen_only
        replaceDict["daily_dozen_and_tweaks"] = "setting_doze_tweak_btn"
        replaceDict["Lef-Iw-Ywr.normalTitle"] = "setting_doze_tweak_btn" // Android: daily_dozen_and_tweaks
        
        // Utilities Menu
        replaceDict["Ebp-Lw-fWk.normalTitle"]      = "setting_util_advanced" // Android: NA
        replaceDict["settings_advanced_utilities"] = "setting_util_advanced" // Android: NA
        replaceDict["setting_advanced_utilities"]  = "setting_util_advanced" // Android: NA
        replaceDict["settings_utilities_advanced"] = "setting_util_advanced" // Android: NA
        
        // Dynamically set `historyRecordWeight.titleImperial` or `historyRecordWeight.titleMetric`   
        dropSet.insert("Tgz-om-dEk.text") // Apple static setting dropped
        dropSet.insert("8ed-5m-QMc.text") // Apple static setting dropped
        replaceDict["moving_average"] = "historyRecord.movingAverage" // Android: moving_average
        
        // `monthLabel` is set from `Date` extension `monthNameLocalized`
        dropSet.insert("nRL-iG-Wnd.text") // date pager `monthLabel` "<< < month > >>"
        dropSet.insert("UCg-Rc-mLf.text") // date pager `monthLabel` "<< < month > >>"
        dropSet.insert("lTR-i5-Tn0.text") // date pager `monthLabel` "<< < month > >>"

        // 'Units:' button title programatically set to unitToggle.imperial or unitToggle.metric
        dropSet.insert("1K3-d9-Hfb.normalTitle") // becomes unitToggle.imperial or unitToggle.metric 
        dropSet.insert("M75-CQ-NVP.normalTitle") // becomes unitToggle.imperial or unitToggle.metric
        replaceDict["imperial"] = "unitToggle.imperial" // toggle button (not setting)
        replaceDict["metric"] = "unitToggle.metric" // toggle button (not setting)
        
        replaceDict["W2v-Cp-vcd.text"] = "dozeOtherInfo.title" // Android: NA
        replaceDict["xcg-0a-oqY.normalTitle"] = "videos.link.label" // Android: videos
        replaceDict["5po-De-kCi.text"] = "tweak_entry_header" // Android: twenty_one_tweaks
        
        // static "100 days" replaced by `%d day`. Apple: streakDaysFormat Droid: format_num_days
        dropSet.insert("cW5-dD-Zy0.text") // Android: format_num_days Apple: streakDaysFormat
        dropSet.insert("Vbn-R9-kuu.text") // Android: format_num_days Apple: streakDaysFormat
        // rational: "streakDaysFormat" is less generic that "format_num_days"
        replaceDict["format_num_days"] = "streakDaysFormat" // Android: format_num_days
        
        // Android uses `out_of` uses text for "X out of Y".
        // Apple programatically uses "X/Y" with no text translation.
        dropSet.insert("NPC-if-gUf.text") // replaced by "X/Y"
        
        // Apple Store: change word separators from `.` to `_`
        replaceDict["apple.store.description.0"] = "apple_store_description.0"
        replaceDict["apple.store.description.1"] = "apple_store_description.1"
        replaceDict["apple.store.description.2"] = "apple_store_description.2"
        replaceDict["apple.store.description.3"] = "apple_store_description.3"
        replaceDict["apple.store.description.4"] = "apple_store_description.4"
        replaceDict["apple.store.description.5"] = "apple_store_description.5"
        replaceDict["apple.store.description.6"] = "apple_store_description.6"
        replaceDict["apple.store.description.7"] = "apple_store_description.7"
        replaceDict["apple.store.promotion"] = "apple_store_promotion"
        replaceDict["apple.store.subtitle"] = "apple_store_subtitle"
        replaceDict["apple.store.title"] = "apple_store_title"
        replaceDict["apple.store.whatsnew"] = "apple_store_whatsnew"
        replaceDict["store.keywords"] = "store_keywords"
        replaceDict["store.screen.0"] = "store_screen.0"
        replaceDict["store.screen.1"] = "store_screen.1"
        replaceDict["store.screen.2"] = "store_screen.2"
        replaceDict["store.screen.3"] = "store_screen.3"
        replaceDict["store.screen.4"] = "store_screen.4"
        replaceDict["store.screen.5"] = "store_screen.5"
        
        // Random IDs no longer used (from Spanish_es cleanup)
        dropSet.insert("5eb-qC-Ke5.text") // 2017
        dropSet.insert("6m3-hV-PBi.text") // Negative Calorie Load
        dropSet.insert("ERa-UT-Rni.text") // 0 / 24
        dropSet.insert("FTS-2y-Iil.text") // 2017
        dropSet.insert("OFE-S4-S9b.text") // Label
        dropSet.insert("YGb-Uj-J69.text") // Label
        dropSet.insert("dld-jq-Etq.text") // 2017
        dropSet.insert("dxC-TB-3hz.text") // Label
        dropSet.insert("iJb-Vn-TS0.text") // Beans
        dropSet.insert("m5s-0r-St1.text") // Label
        dropSet.insert("pKR-lY-XXM.text") // Today
        dropSet.insert("qWl-8e-sO6.text") // Label
        dropSet.insert("yct-Iw-M3s.text") // Label
        dropSet.insert("zV0-lA-zHj.text") // lbs.
    }
    
    func isDropped(_ key: String) -> Bool {
        return dropSet.contains(key)
    }
    
    func isReplaced(_ key: String) -> String? {
        return replaceDict[key]
    }
    
}
