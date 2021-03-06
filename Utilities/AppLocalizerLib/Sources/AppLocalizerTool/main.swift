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

// :NYI: support `BatchCommands` as parameter. check for default file is no parameter.

// batch_replicate_DroidToTSV.txt
// batch_replicate_TsvToApple.txt

// batch_diff_xliff.txt
// batch_diff_tsv_update_af.txt
// batch_diff_tsv_update__all.txt
// batch_replicate_DroidToTsv.txt
// batch_export_es.txt
// batch_export_pl_es.txt
// batch_import_es.txt
// batch_import_pl.txt
// batch_import_de.txt: de, pl
let BatchCommands = "batch_replicate_TsvToApple.txt"
print("### \(BatchCommands) ###")

// …/AppLocalizerLibTests.bundle/Resources/commands_*.txt
// Content: batch commands file
///…/Debug/AppLocalizerLib_AppLocalizerLib.bundle/Contents/Resources/BatchCommands
let commandsDir = productsDir
    .appendingPathComponent("AppLocalizerLib_AppLocalizerLib.bundle")
    .appendingPathComponent("Contents", isDirectory: true)
    .appendingPathComponent("Resources", isDirectory: true)
    .appendingPathComponent("BatchCommands", isDirectory: true)
let commandsFile = commandsDir
    .appendingPathComponent(BatchCommands, isDirectory: false)
print("commandsDir=\(commandsDir.absoluteString)")
print("commandsFile=\(commandsFile.absoluteString)")

// …/AppLocalizerLibTests.bundle/Languages/ 
// copy from daily-dozen-localization/Languages
//  e.g. Languages/Spanish/android/, …ios/, …tsv/
guard let nfLanguages = AppLocalizer.environmentNFLanguages else {
    print("NF_LOCALE_LANG_ALL not found")
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
