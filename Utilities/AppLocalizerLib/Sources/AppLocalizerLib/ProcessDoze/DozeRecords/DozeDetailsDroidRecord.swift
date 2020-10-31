//
//  DozeDetailsDroidRecord.swift
//  AppLocalizerLib
//

import Foundation

// first pass reading in Android XML
struct DozeDetailsDroidRecord {
    // heading
    
    struct Serving {
        var imperial: String = ""
        var metric: String = ""
        var text: String = ""
    }
    
    struct Variety {
        var text: String = ""
        var topic: String = "" // url component
    }

    /// <string name="beans">Beans</string>
    var heading: String = ""
    var servings: [Serving] = [Serving]()
    var varieties: [Variety] = [Variety]()
    /// <string name="food_info_videos_beans">Beans</string>
    var topic: String = ""
}
