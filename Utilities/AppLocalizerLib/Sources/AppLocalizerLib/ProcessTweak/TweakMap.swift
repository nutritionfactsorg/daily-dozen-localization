//
//  TweakMap.swift
//  AppLocalizerLib
//

import Foundation

/// Android to iOS key pairs
let mapTweakKeys: [String: String] = [
    "meal_water": "tweakMealWater",
    "meal_negcal": "tweakMealNegCal",
    "meal_vinegar": "tweakMealVinegar",
    "meal_undistracted": "tweakMealUndistracted",
    "meal_twentyminutes": "tweakMeal20Minutes",
    "daily_blackcumin": "tweakDailyBlackCumin",
    "daily_garlic": "tweakDailyGarlic",
    "daily_ginger": "tweakDailyGinger",
    "daily_nutriyeast": "tweakDailyNutriYeast",
    "daily_cumin": "tweakDailyCumin",
    "daily_greentea": "tweakDailyGreenTea",
    "daily_hydrate": "tweakDailyHydrate",
    "daily_deflourdiet": "tweakDailyDeflourDiet",
    "daily_frontload": "tweakDailyFrontLoad",
    "daily_timerestrict": "tweakDailyTimeRestrict",
    "exercise_timing": "tweakExerciseTiming",
    "weigh_twice": "tweakWeightTwice",
    "complete_intentions": "tweakCompleteIntentions",
    "nightly_fast": "tweakNightlyFast",
    "nightly_sleep": "tweakNightlySleep",
    "nightly_trendelenburg": "tweakNightlyTrendelenbrug"
]

/// iOS to Android key pairs
//let mapTweakIosToDroidKeys: [String: String] = [
//    "tweakMealWater": "meal_water",
//    "tweakMealNegCal": "meal_negcal",
//    "tweakMealVinegar": "meal_vinegar",
//    "tweakMealUndistracted": "meal_undistracted",
//    "tweakMeal20Minutes": "meal_twentyminutes",
//    "tweakDailyBlackCumin": "daily_blackcumin",
//    "tweakDailyGarlic": "daily_garlic",
//    "tweakDailyGinger": "daily_ginger",
//    "tweakDailyNutriYeast": "daily_nutriyeast",
//    "tweakDailyCumin": "daily_cumin",
//    "tweakDailyGreenTea": "daily_greentea",
//    "tweakDailyHydrate": "daily_hydrate",
//    "tweakDailyDeflourDiet": "daily_deflourdiet",
//    "tweakDailyFrontLoad": "daily_frontload",
//    "tweakDailyTimeRestrict": "daily_timerestrict",
//    "tweakExerciseTiming": "exercise_timing",
//    "tweakWeightTwice": "weigh_twice",
//    "tweakCompleteIntentions": "complete_intentions",
//    "tweakNightlyFast": "nightly_fast",
//    "tweakNightlySleep": "nightly_sleep",
//    "tweakNightlyTrendelenbrug": "nightly_trendelenburg"
//]


///  IN: <string name="meal_water">Preload with Water</string>
/// OUT: *.xliff --> Localizable.strings
/// Note: same as tweaks checklist headings // :!!!:NYI: full vs. brief headings
let mapTweakChecklistHeadings: [String: String] = [
    "meal_water": "tweakMealWater.heading", // :!!!: iOS key?
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
    "daily_deflourdiet": "tweakDailyDeflourDiet.heading",
    "daily_frontload": "tweakDailyFrontLoad.heading",
    "daily_timerestrict": "tweakDailyTimeRestrict.heading",
    "exercise_timing": "tweakExerciseTiming.heading",
    "weigh_twice": "tweakWeightTwice.heading",
    "complete_intentions": "tweakCompleteIntentions.heading",
    "nightly_fast": "tweakNightlyFast.heading",
    "nightly_sleep": "tweakNightlySleep.heading",
    "nightly_trendelenburg": "tweakNightlyTrendelenbrug.heading"
]

///  IN: <string name="meal_water_short">Preload with Water</string>
/// OUT: TweakDetails.json
/// Note: Details "Activity" summary segments
let mapTweakDetailsShort: [String: String] = [
    "meal_water_short": "tweakMealWater.activity",
    "meal_negcal_short": "tweakMealNegCal.activity",
    "meal_vinegar_short": "tweakMealVinegar.activity",
    "meal_undistracted_short": "tweakMealUndistracted.activity",
    "meal_twentyminutes_short": "tweakMeal20Minutes.activity",
    "daily_blackcumin_short": "tweakDailyBlackCumin.activity",
    "daily_garlic_short": "tweakDailyGarlic.activity",
    "daily_ginger_short": "tweakDailyGinger.activity",
    "daily_nutriyeast_short": "tweakDailyNutriYeast.activity",
    "daily_cumin_short": "tweakDailyCumin.activity",
    "daily_greentea_short": "tweakDailyGreenTea.activity",
    "daily_hydrate_short": "tweakDailyHydrate.activity",
    "daily_deflourdiet_short": "tweakDailyDeflourDiet.activity",
    "daily_frontload_short": "tweakDailyFrontLoad.activity",
    "daily_timerestrict_short": "tweakDailyTimeRestrict.activity",
    "exercise_timing_short": "tweakExerciseTiming.activity",
    "weigh_twice_short": "tweakWeightTwice.activity",
    "complete_intentions_short": "tweakCompleteIntentions.activity",
    "nightly_fast_short": "tweakNightlyFast.activity",
    "nightly_sleep_short": "tweakNightlySleep.activity",
    "nightly_trendelenburg_short": "tweakNightlyTrendelenbrug.activity"
]

///  IN: <string name="meal_water_text">Time your metabolism-boosting two…</string>
/// OUT: TweakDetails.json
/// Note: Details "Description" text segments
let mapTweakDetailsText: [String: String] = [
    "meal_water_text": "tweakMealWater.description",
    "meal_negcal_text": "tweakMealNegCal.description",
    "meal_vinegar_text": "tweakMealVinegar.description",
    "meal_undistracted_text": "tweakMealUndistracted.description",
    "meal_twentyminutes_text": "tweakMeal20Minutes.description",
    "daily_blackcumin_text": "tweakDailyBlackCumin.description",
    "daily_garlic_text": "tweakDailyGarlic.description",
    "daily_ginger_text": "tweakDailyGinger.description",
    "daily_nutriyeast_text": "tweakDailyNutriYeast.description",
    "daily_cumin_text": "tweakDailyCumin.description",
    "daily_greentea_text": "tweakDailyGreenTea.description",
    "daily_hydrate_text": "tweakDailyHydrate.description",
    "daily_deflourdiet_text": "tweakDailyDeflourDiet.description",
    "daily_frontload_text": "tweakDailyFrontLoad.description",
    "daily_timerestrict_text": "tweakDailyTimeRestrict.description",
    "exercise_timing_text": "tweakExerciseTiming.description",
    "weigh_twice_text": "tweakWeightTwice.description",
    "complete_intentions_text": "tweakCompleteIntentions.description",
    "nightly_fast_text": "tweakNightlyFast.description",
    "nightly_sleep_text": "tweakNightlySleep.description",
    "nightly_trendelenburg_text": "tweakNightlyTrendelenbrug.description"
]
