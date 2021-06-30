import Foundation
import AppLocalizerLib

#if DEBUG
//print(getEnvironment())
#endif

guard #available(macOS 10.15, *) else {
    print("testAppLocalizerLib() requires macOS 10.15 or higher")
    exit(EXIT_FAILURE) 
}

/// Returns path to the built products directory.
var productsDir: URL {
    #if os(macOS)
    print("mainBundle.executablePath\n\(Bundle.main.bundlePath)")
    //print("mainBundle.executablePath\n\(Bundle.main.executablePath!)")
    //print("mainBundle.resourcePath\n\(Bundle.main.resourcePath!)")
    
    return Bundle.main.bundleURL
    #else
    return Bundle.main.bundleURL
    #endif
}

// :NYI: handle
//let argv = ProcessInfo().arguments

// :NYI: support `commandSet` as parameter. check for default file is no parameter.
// commands_diff_pl.txt
// commands_diff_tsv.txt
// commands_diff_tsv_update.txt
// commands_export_droid.txt
// commands_export_es.txt
// commands_import_droid.txt
// commands_export_pl_es.txt
// commands_import_es.txt
// commands_import_pl.txt
// commands_import_de.txt: de, pl
// commands_testcase_01.txt: 01, es, de
let commandSet = "commands_import_droid.txt"
print("### \(commandSet) ###")

// …/AppLocalizerLibTests.bundle/Resources/commands_*.txt
// Content: batch commands file
///…/Debug/AppLocalizerLib_AppLocalizerLib.bundle/Contents/Resources/Commands
let commandsDir = productsDir
    .appendingPathComponent("AppLocalizerLib_AppLocalizerLib.bundle")
    .appendingPathComponent("Contents", isDirectory: true)
    .appendingPathComponent("Resources", isDirectory: true)
    .appendingPathComponent("Commands", isDirectory: true)
let commandsFile = commandsDir
    .appendingPathComponent(commandSet, isDirectory: false)
print("commandsDir=\(commandsDir.absoluteString)")
print("commandsFile=\(commandsFile.absoluteString)")

// …/AppLocalizerLibTests.bundle/Languages/ 
// copy from daily-dozen-localization/Languages
//  e.g. Languages/Spanish/android/, …ios/, …tsv/
guard let nfLanguages = AppLocalizer.environmentNFLanguages else {
    print("NF_LANGUAGES not found")
    exit(EXIT_FAILURE)
}

let languagesDir = URL(fileURLWithPath: nfLanguages, isDirectory: true)
print("languagesDir=\(languagesDir.absoluteString.removingPercentEncoding!)")

// …/AppLocalizerLib.bundle/Resources/ …Doze/ and …Tweak/
// Content: Android <--> Apple mapping files 
let mappingsDir = productsDir
    .appendingPathComponent("AppLocalizerLib.bundle")
    .appendingPathComponent("Resources", isDirectory: true)
print("mappingsDir=\(mappingsDir.absoluteString)")

let appLocalizer = AppLocalizer()
appLocalizer.run( // BatchRunner
    commandsUrl: commandsFile,
    languagesUrl: languagesDir,
    mappingsUrl: mappingsDir
)

exit(EXIT_SUCCESS)
