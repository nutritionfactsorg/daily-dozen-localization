//
//  DozeMapChecklist.swift
//  AppLocalizerLib
//

import Foundation

/// :!!!: verify KEY uniqueness

///  IN: <string name=>
/// OUT: Localizable.strings
let pairedDozeStrings: [String: String] = [

/* ***** Daily Dozen ***** */
"beans": "dozeBeans.heading",
"berries": "dozeBerries.heading",
"other_fruits": "dozeFruitsOther.heading",
"cruciferous_vegetables": "dozeVegetablesCruciferous.heading",
"greens": "dozeGreens.heading",
"other_vegetables": "dozeVegetablesOther.heading",
"flaxseeds": "dozeFlaxseeds.heading",
"nuts": "dozeNuts.heading",
"spices": "dozeSpices.heading",
"whole_grains": "dozeWholeGrains.heading",
"beverages": "dozeBeverages.heading",
"exercise": "dozeExercise.heading",
/* ***** Daily Dozen Other ***** */
"vitamin_b12": "otherVitaminB12.heading",
//"": "otherVitaminD.heading", // :TRANSLATE:MANUAL: Android not present
//"": "otherOmega3.heading",   // :TRANSLATE:MANUAL: Android not present
/* ***** 21 Tweak ***** */
"meal_water": "tweakMealWater.heading",
"meal_negcal": "tweakMealNegCal.heading",
"meal_vinegar": "tweakMealVinegar.heading",
"meal_undistracted": "tweakMealUndistracted.heading",
"meal_twentyminutes": "tweakMeal20Minutes.heading",
"daily_blackcumin": "tweakDailyBlackCumin.heading",
"daily_garlic": "tweakDailyGarlic.heading",
"daily_ginger": "tweakDailyGinger.heading",
"daily_nutriyeast": "tweakDailyNutriYeast.heading",
"daily_cumin": "tweakDailyCumin.heading",
"daily_greentea": "tweakDailyGreenTea.heading",
"daily_hydrate": "tweakDailyHydrate.heading",
//"daily_deflourdiet": "tweakDailyDeflourDiet.heading", // :!!!:TRANSLATE: Android es unchanged "Granos Intactos"
"daily_frontload": "tweakDailyFrontLoad.heading",
"daily_timerestrict": "tweakDailyTimeRestrict.heading",
"exercise_timing": "tweakExerciseTiming.heading",
"weigh_twice": "tweakWeightTwice.heading",
"complete_intentions": "tweakCompleteIntentions.heading",
"nightly_fast": "tweakNightlyFast.heading",
"nightly_sleep": "tweakNightlySleep.heading",
"nightly_trendelenburg": "tweakNightlyTrendelenbrug.heading"
]

///  IN: <string name=>
/// OUT: id
let pairedStringId: [String: String] = [

// About.storyboard
// "app_name": "DJR-bj-qUq.text",         // "Daily Dozen" :TRANSLATE:NO:
// "about_text_lines": "Zgt-w4-qQw.text", // "This app…"   :TRANSLATE:MANUAL:
"welcome_to_my_daily_dozen": "19L-gq-W5M.text",
"activity_welcome_text": "dwQ-CS-gz3.text",
// "":"gX5-vX-xBe.text" // version 3.x  :TRANSLATE:MANUAL:NYI: set number via :CODE: 

// FirstLaunch.storyboard
//"activity_welcome_text": "", // Use this app.. :TRANSLATE:REMOVED:
"for_health_alone": "atR-un-jgX.text",              // "For Health Alone"
"daily_dozen_only": "ReM-AP-Fpp.normalTitle",       // "Daily Dozen Only"
"for_health_and_weight_loss": "OdG-YQ-lT8.text",    // "For Health and Weight Loss"
"daily_dozen_and_tweaks": "Lef-Iw-Ywr.normalTitle", // "Daily Dozen + 21 Tweak"

// DetailsDoze.storyboard
"videos": "xcg-0a-oqY.normalTitle", 
// "": "iJb-Vn-TS0.text" // Image title overlay place holder
// "": "m5s-0r-St1.text" // Label place holder  :TRANSLATE:CODE_BASED: marcador de posición
// "": "yct-Iw-M3s.text" // Label place holder  :TRANSLATE:CODE_BASED: marcador de posición

// DetailsTweaks.storyboard
// "": "6m3-hV-PBi.text" // Image title overlay place holder
// "": "OFE-S4-S9b.text" // Label place holder  :TRANSLATE:CODE_BASED: marcador de posición
// "": "dxC-TB-3hz.text" // Label place holder  :TRANSLATE:CODE_BASED: marcador de posición


// ----- Imperial|Metric -----
// Spanish (es) Imperial|Métrico
// :TRANSLATE:!!!:NYI: metric/imperial button in code. also match case sensitivy
//"metric": "1K3-d9-Hfb.normalTitle", // :TRANSLATE:!!!:NYI: metric/imperial button code
//"metric": "M75-CQ-NVP.normalTitle", // :TRANSLATE:!!!:NYI: metric/imperial button code
// SizesHeader.xib
"metric": "1K3-d9-Hfb.normalTitle", 
// SizesTweaksHeader.xib
"metric": "M75-CQ-NVP.normalTitle",
// Settings.storyboard
"imperial": "RLb-GV-4hh.segmentTitles[0]",
"metric": "RLb-GV-4hh.segmentTitles[1]",
// "": "RLb-GV-4hh.segmentTitles[2]",  // :TRANSLATE:MANUAL: Toggle Units

// Daily Dozen Details: SizesHeader.xib
// Daily Dozen Details: TypesHeader.xib                              
"units": "3bd-8h-kcX.text",          // "Units:" see also Imperial|Metric
"serving_sizes": "eU6-je-hVN.text",  // "Serving Sizes"
"types": "YVI-sV-TDX.text",          // "Types"

// Tweak Details: SizesTweaksHeader.xib
// Tweak Details: TypesTweaksHeader.xib
"units": "kho-9G-OWe.text",  // "Units:" see also Imperial|Metric
//"": "YVI-sV-TDA.text",     // "Activity"    :TRANSLATE: no android equivalent 
//"": "YVI-sV-TDD.text",     // "Description" :TRANSLATE: no android equivalent

// ItemHistory.storyboard
"servings_all": "S0Q-oB-VgE.text", 
"servings_some": "jBv-4d-ofX.text",
"history": "sLd-Kq-bLv.text",

// Menu.storyboard
//"More" ??
"latest_videos": "uxH-8I-ydF.text", // Latest Videos
//"": "zQy-Dn-WXM.text", // Libro: How Not to Die           :???:TRANSLATE:NO:
//"": "Cxo-5D-YUZ.text", // Libro: How Not to Die Cookbook  :???:TRANSLATE:NO:
//"": "MWr-7S-G8N.text", // Libro: How Not to Diet          :???:TRANSLATE:NO:
//"daily_dozen_challenge": "beF-Xl-TAq.text", // Challenge? :???:TRANSLATE:NO:
"donate": "mqA-Vp-LZ7.text", // Donate
"subscribe": "dRO-1W-3EK.text", // Subscribe
"open_source": "qVR-SQ-jmS.text", // Open Source
"about": "qGY-wh-1gB.text", // About

// Servings.storyboard
"servings": "1HM-mL-ZV9.text", // Servings
"out_of": "ERa-UT-Rni.text",   // "0 out of 24" "out of"  :!!!:TRANSLATE:CODE_BASED:
//"format_num_days": "cW5-dD-Zy0.text", // 100 days :!!!:TRANSLATE:CODE_FORMAT: %d days
// "": "qWl-8e-sO6.text", // Label place holder     :!!!:TRANSLATE:CODE_BASED: marcador de posición

// Tweak.storyboard
"twenty_one_tweaks": "5po-De-kCi.text", // 21 Tweak (see also Android "tweaks")
"out_of": "NPC-if-gUf.text",   // "0 out of 37" "out of" "de" :!!!:TRANSLATE:CODE_BASED:
//"format_num_days": "Vbn-R9-kuu.text", // 100 days :!!!:TRANSLATE:CODE_FORMAT: %d days
// "": "YGb-Uj-J69.text", // Label place holder     :!!!:TRANSLATE:CODE_BASED: marcador de posición

// --- ServingsPager.storyboard ---
//"": "OC8-wt-JgC.normalTitle", // Today :!!!:TRANSLATE:CODE: dateButton.setTitle
"back_to_today": "Qfe-bW-SP4.normalTitle", // Back to today
// --- TweakPager.storyboard ---
//"": "iHh-5a-01X.normalTitle", // Today :!!!:TRANSLATE:CODE: dateButton.setTitle
"back_to_today": "7XY-Lo-Hwf.normalTitle", // Back to today
// --- WeightPager.storyboard ---
//"": "6FY-X2-BdZ.normalTitle", // Today :!!!:TRANSLATE:CODE: dateButton.setTitle
"back_to_today": "OIQ-oh-3QN.normalTitle", // Back to today

// SupplementsHeader.xib
// "": "W2v-Cp-vcd.text", :TRANSLATE:MANUAL:

// --- Settings.storyboard ---
//"": "Ebp-Lw-fWk.normalTitle", // :TRANSLATE:MANUAL: Advanced Utilities
"": "",
//"": "IFs-g0-SPV.headerTitle", // :TRANSLATE:MANUAL: Measurement Units
//"": "IFs-g0-SPV.footerTitle", // :TRANSLATE:MANUAL: Set to be one unit type …
//"": "WdR-XV-IyP.headerTitle", // :TRANSLATE:MANUAL: 21 Tweak Visibility 
"daily_dozen_only": "OZO-Xa-v5G.segmentTitles[0]",       // Daily Dozen Only
"daily_dozen_and_tweaks": "OZO-Xa-v5G.segmentTitles[1]", // Daily Dozen + 21 Tweak
//"": "WdR-XV-IyP.footerTitle", // :TRANSLATE:MANUAL: For health alone, use …
// --- Settings.storyboard: Reminders ---
//"daily_reminder_title": "GiY-ao-2ee.headerTitle", // Daily Reminder :TRANSLATE:MANUAL: vs. Android "Daily Dozen Reminder" Title
"daily_reminder_settings": "itH-G7-Kal.text", // Enable Reminders > goto subview
// "": "XFw-2q-BdT.text", // :!!!:TRANSLATE:CODE:MANUAL: On|Off (En|Apagado)
"enable_daily_reminder": "pjz-An-Ls5.text",   // Enable Reminders On|Off toggle 
"remind_me_at": "kR3-Sa-Fpt.text",            // Remind me at:
"play_sound": "YP6-dP-Y62.text",              // Play Sound

// --- Weight.storyboard ---
//"": "NRG-eE-YhG.normalTitle", // ClearAM :TRANSLATE:MANUAL: Borrar
//"": "IeK-uC-yhe.normalTitle", // SaveAM  :TRANSLATE:MANUAL: Guardar
//"": "7l0-os-Oqt.normalTitle", // ClearPM :TRANSLATE:MANUAL: Borrar
//"": "Eai-xa-KOK.normalTitle", // SavePM  :TRANSLATE:MANUAL: Guardar
//"": "Tgz-om-dEk.text", // "lbs." AM :!!!:TRANSLATE:CODE: weightAMLabel lbs|kg 
//"": "8ed-5m-QMc.text", // "lbs." PM :!!!:TRANSLATE:CODE: weightPMLabel lbs|kg 
"": "FBJ-Im-BZk.text", // Time AM :TRANSLATE:MANUAL: Tiempo
"": "g3G-kp-d2S.text", // Time PM :TRANSLATE:MANUAL: Tiempo
//"": "xCp-N8-5Uc.text", // Morning (upon waking)      :TRANSLATE:MANUAL:
//"": "77g-xa-ali.text", // Evening (right before bed) :TRANSLATE:MANUAL:

// --- ServingsHistory.storyboard ---
// --- TweakHistory.storyboard ---
// --- WeightHistory.storyboard ---
"time_scale": "27q-rq-qbu.text",
"time_scale": "XdW-g4-ZUO.text",
"time_scale": "v2E-Ao-OVz.text", // :!!!:TRANSLATE: Android capitalization rules Escala de tiempo
// ---
//"": "nRL-iG-Wnd.text", // "Month" :TRANSLATE:CODE: `monthLabel`
//"": "UCg-Rc-mLf.text", // "Month" :TRANSLATE:CODE: `monthLabel`
//"": "lTR-i5-Tn0.text", // "Month" :TRANSLATE:CODE: `monthLabel`
// --- [Day|Month|Year] :TRANSLATE:CODE: `scaleControl` servings_time_scale_choices
"servings_time_scale_choices[0]": "sM6-A9-KeP.segmentTitles[0]", // Day `scaleControl`
"servings_time_scale_choices[1]": "sM6-A9-KeP.segmentTitles[1]", // Month
"servings_time_scale_choices[2]": "sM6-A9-KeP.segmentTitles[2]", // Year
"servings_time_scale_choices[0]": "vXy-0q-Ind.segmentTitles[0]", // Day `scaleControl`
"servings_time_scale_choices[1]": "vXy-0q-Ind.segmentTitles[1]", // Month
"servings_time_scale_choices[2]": "vXy-0q-Ind.segmentTitles[2]", // Year
"servings_time_scale_choices[0]": "fcu-ZA-byN.segmentTitles[0]", // Day `scaleControl`
"servings_time_scale_choices[1]": "fcu-ZA-byN.segmentTitles[1]", // Month
"servings_time_scale_choices[2]": "fcu-ZA-byN.segmentTitles[2]", // Year
// --- WeightHistory.storyboard only
//"": "8ed-5m-QMc.text", // "Weight (lbs.)" "!!!:TRANSLATE:CODE: `weightTitleUnits`
//"": "XYD-fX-adn.normalTitle", // "Edit Data" :TRANSLATE:MANUAL:

// InfoPlist.strings
//"": "CFBundleName",                   // :TRANSLATE:NO_CHANGE:
//"": "DailyDozen",                     // :TRANSLATE:NO_CHANGE:
//"": "NSHealthShareUsageDescription",  // :TRANSLATE:MANUAL:
//"": "NSHealthUpdateUsageDescription", // :TRANSLATE:MANUAL:
]

