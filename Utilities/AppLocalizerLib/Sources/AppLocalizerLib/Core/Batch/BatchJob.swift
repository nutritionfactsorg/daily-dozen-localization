//
//  BatchJob.swift
//  AppLocalizerLib
//
//

import Foundation

public struct BatchJob {
    
    /// .../Languages/
    var dataDir: URL
    
    // --- Android ---
    /// input: Android base development language URL `strings.xml` (English)
    var droidBaseXmlInputUrl: URL
    /// input: Android target language URL `strings.xml`
    var droidLangXmlInputUrl: URL
    // --- Apple ---
    /// input: Apple base development language URL `en.xcloc`(English)
    var appleBaseXliffInputUrl: URL
    /// input: Apple target language URL e.g. `es.xcloc`
    var appleLangXliffInputUrl: URL
    /// input: 
    var appleBaseDozeJsonInputUrl: URL
    /// input: 
    var appleLangDozeJsonInputUrl: URL
    /// input:
    var appleBaseTweakJsonInputUrl: URL
    /// input:
    var appleLangTweakJsonInputUrl: URL
    // --- TSV ---
    /// output:
    var tsvExportUrl: URL
    /// output:
    var tsvDozeDetailsUrl: URL
    /// output:
    var tsvTweakDetailsUrl: URL
    /// input: 
    var tsvImportUrl: URL
    
    public init(workingDataDir: URL, language: Language) {
        /// from command line "dataPath="
        self.dataDir = workingDataDir
        let datestamp = Date().datestampyyyyMMdd
        
        /// …Languages/English (en)/android/values-en/strings.xml
        self.droidBaseXmlInputUrl = workingDataDir
            .appendingPathComponent(BatchJob.Language.en.dirName)
            .appendingPathComponent("android")
            .appendingPathComponent("values-\(BatchJob.Language.en.codeAndroid)")
            .appendingPathComponent("strings.xml", isDirectory: false)
        
        /// …Languages/Spanish (es)/android/values-es/strings.xml
        self.droidLangXmlInputUrl = workingDataDir
            .appendingPathComponent("\(language.dirName)")
            .appendingPathComponent("android")
            .appendingPathComponent("values-\(language.codeAndroid)")
            .appendingPathComponent("strings.xml", isDirectory: false)
        
        /// …Languages/English (en)/ios/en.xcloc/Localized Contents/en.xliff
        self.appleBaseXliffInputUrl = workingDataDir
            .appendingPathComponent(BatchJob.Language.en.dirName)
            .appendingPathComponent("ios")
            .appendingPathComponent("\(BatchJob.Language.en.codeApple).xcloc")
            .appendingPathComponent("Localized Contents")
            .appendingPathComponent("\(BatchJob.Language.en.codeApple).xliff", isDirectory: false)
        
        /// …Languages/English (en)/ios/en.xcloc/Localized Contents/en.xliff
        self.appleLangXliffInputUrl = workingDataDir
            .appendingPathComponent(language.dirName)
            .appendingPathComponent("ios")
            .appendingPathComponent("\(language.codeApple).xcloc")
            .appendingPathComponent("Localized Contents")
            .appendingPathComponent("\(language.codeApple).xliff", isDirectory: false)
        
        /// …/Languages/English (en)/ios/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/en.lproj/DozeDetailData.json
        self.appleBaseDozeJsonInputUrl = workingDataDir
            .appendingPathComponent(BatchJob.Language.en.dirName)
            .appendingPathComponent("ios")
            .appendingPathComponent("\(language.codeApple).xcloc")
            .appendingPathComponent("Localized Contents")
            .appendingPathComponent("DailyDozen")
            .appendingPathComponent("App")
            .appendingPathComponent("Texts")
            .appendingPathComponent("LocalStrings")
            .appendingPathComponent("\(language.codeApple).lproj")
            .appendingPathComponent("DozeDetailData.json", isDirectory: false)
        
        /// …/Languages/Spanish (es)/ios/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/en.lproj/DozeDetailData.json
        self.appleLangDozeJsonInputUrl = workingDataDir
            .appendingPathComponent(language.dirName)
            .appendingPathComponent("ios")
            .appendingPathComponent("\(language.codeApple).xcloc")
            .appendingPathComponent("Localized Contents")
            .appendingPathComponent("DailyDozen")
            .appendingPathComponent("App")
            .appendingPathComponent("Texts")
            .appendingPathComponent("LocalStrings")
            .appendingPathComponent("\(language.codeApple).lproj")
            .appendingPathComponent("DozeDetailData.json", isDirectory: false)
        
        /// …/Languages/English (en)/ios/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/en.lproj/TweakDetailData.json
        self.appleBaseTweakJsonInputUrl = workingDataDir
            .appendingPathComponent(BatchJob.Language.en.dirName)
            .appendingPathComponent("ios")
            .appendingPathComponent("\(language.codeApple).xcloc")
            .appendingPathComponent("Localized Contents")
            .appendingPathComponent("DailyDozen")
            .appendingPathComponent("App")
            .appendingPathComponent("Texts")
            .appendingPathComponent("LocalStrings")
            .appendingPathComponent("\(language.codeApple).lproj")
            .appendingPathComponent("TweakDetailData.json", isDirectory: false)
        
        /// …/Languages/Spanish (es)/ios/en.xcloc/Localized Contents/DailyDozen/App/Texts/LocalStrings/en.lproj/TweakDetailData.json
        self.appleLangTweakJsonInputUrl = workingDataDir
            .appendingPathComponent(language.dirName)
            .appendingPathComponent("ios")
            .appendingPathComponent("\(language.codeApple).xcloc")
            .appendingPathComponent("Localized Contents")
            .appendingPathComponent("DailyDozen")
            .appendingPathComponent("App")
            .appendingPathComponent("Texts")
            .appendingPathComponent("LocalStrings")
            .appendingPathComponent("\(language.codeApple).lproj")
            .appendingPathComponent("TweakDetailData.json", isDirectory: false)
        
        /// …/Languages/English (en)/tsv/de-20200219-export.tsv
        self.tsvExportUrl = workingDataDir
            .appendingPathComponent(language.dirName)
            .appendingPathComponent("tsv")
            .appendingPathComponent("\(language.codeAndroid)-export.tsv", isDirectory: false)

        //self.tsvExportUrl = workingDataDir
        //    .appendingPathComponent(language.dirName)
        //    .appendingPathComponent("tsv")
        //    .appendingPathComponent("\(language.codeAndroid)-\(datestamp)-export.tsv", isDirectory: false)
        
        /// …/Languages/English (en)/tsv/de-20200219-import.tsv
        self.tsvImportUrl = workingDataDir
            .appendingPathComponent(language.dirName)
            .appendingPathComponent("tsv")
            .appendingPathComponent("\(language.codeAndroid)-\(datestamp)-import.tsv", isDirectory: false)

        ///   tsvDozeDetailsPath= …/DozeDetails-en.tsv
        self.tsvDozeDetailsUrl = workingDataDir
            .appendingPathComponent("_Test")
            .appendingPathComponent("\(language.codeAndroid)-\(datestamp)-doze-export", isDirectory: false)
        
        ///  tsvTweakDetailsPath= …/TweakDetails-en.tsv
        self.tsvTweakDetailsUrl = workingDataDir
            .appendingPathComponent("_Test")
            .appendingPathComponent("\(language.codeAndroid)-\(datestamp)-tweak-export.tsv", isDirectory: false)
    }
    
    public enum Language: CaseIterable {
        /// Template
        case _t
        /// Bulgarian
        case bg
        /// Catalan
        case ca
        /// German
        case de
        /// Greek
        case el
        /// English
        case en
        /// English, Great Britain
        case en_rGB
        /// Spanish
        case es
        /// French
        case fr
        /// Hungarian
        case hu
        /// Italian
        case it
        /// Japanese
        case jp
        /// Portuguese
        case pt
        /// Romanian
        case ro
        /// Russian
        case ru
        /// Chinese
        case zh
        
        public var codeAndroid: String {
            switch self {
            case ._t: return "_t"
            case .bg: return "bg"
            case .ca: return "ca"
            case .de: return "de"
            case .el: return "el"
            case .en: return "en"
            case .en_rGB: return "en-rGB"
            case .es: return "es"
            case .fr: return "fr"
            case .hu: return "hu"
            case .it: return "it"
            case .jp: return "jp"
            case .pt: return "pt"
            case .ro: return "ro"
            case .ru: return "ru"
            case .zh: return "zh"
            }
        }
        
        public var codeApple: String {
            switch self {
            case ._t: return "_t"
            case .ca: return "ca"
            case .de: return "de"
            case .bg: return "bg"
            case .el: return "el"
            case .en: return "en"
            case .en_rGB: return "en-GB"
            case .es: return "es"
            case .fr: return "fr"
            case .hu: return "hu"
            case .it: return "it"
            case .jp: return "jp"
            case .pt: return "pt"
            case .ro: return "ro"
            case .ru: return "ru"
            case .zh: return "zh"
            }
        }
        
        public var dirName: String {
            switch self {
            case ._t: return "_Template (_t)"
            case .bg: return "Bulgarian (bg)"
            case .ca: return "Catalan (ca)" // :WIP:
            case .de: return "German (de)"
            case .el: return "Greek (el)"
            case .en: return "English (en)"
            case .en_rGB: return "English, Great Britain (en-rGB)" // :WIP:
            case .es: return "Spanish (es)"
            case .fr: return "French (fr)"
            case .hu: return "Hungarian (hu)" // :WIP:
            case .it: return "Itialian (it)"
            case .jp: return "Japanese (jp)" // :WIP:
            case .pt: return "Portuguese (pt)"
            case .ro: return "Romanian (ro)"
            case .ru: return "Russian (ru)"
            case .zh: return "Chinese (zh)"
            }
        }
    }
    
}

