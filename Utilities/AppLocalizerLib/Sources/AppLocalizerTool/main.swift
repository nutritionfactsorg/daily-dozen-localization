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
// batch_export_es.txt
// batch_export_pl_es.txt
// batch_import_es.txt
// batch_import_pl.txt
// batch_import_de.txt: de, pl

// :NOTES: batch_export_pass01 vs batch_replicate_DroidToTsv
// batch_export_pass01.txt
// batch_replicate_DroidToTsv.txt
// "batch_replicate_TsvToApple.txt" // :WIP: for test version

// ::WIP::
// ___ Check en_US baseline: batch_diff_tsv_enUS.txt

// ::WIP:: Normalize

// (TEST)
//let BatchSubdir = "batch_normal"
//let BatchCommands = "batch_normal_FromTsvTest.txt"

// (0) XLIFF use to review current App keywords to lang repo
// -- NORMALIZE: repo xliff -> strings
//let BatchSubdir = "batch_normal"
//let BatchCommands = "batch_normal_FromXliff.txt"

// (1) TSV MAIN REPO ("truth") to "NORMALIZED" product files 
// -- Generated normalized `*.tsv`, `*.json`, `*.string`, `*.xml`
// -- Manually verify/sync normalized Englich results to existing App English files.
// -- Rerun, and repeat verify/sync until English main repo is fully up to date.
// -- Compare normalized English-Language tsv keywords. Updates as needed.
//let BatchSubdir = "batch_normal"
//let BatchCommands = "batch_normal_FromTsvMain.txt"
//let BatchCommands = "batch_normal_FromTsvMain_es.txt" // update spanish

// (2) TSV INTAKE to "NORMALIZED" .tsv, .json, .string, .xml  
// -- INTAKE: include/exclude languages as needed
// -- Compare/Update main repo with normalized intake tsv
// -- Compare/Propagate intake/main result with app files (localization, android, ios)
let BatchSubdir = "batch_normal"
let BatchCommands = "batch_normal_FromTsvIntakeB.txt"   // *B*aseline
//let BatchCommands = "batch_normal_FromTsvIntakeB+C.txt" // *B*aseline + *C*hangeSet
//let BatchCommands = "batch_normal_FromTsvIntakeC.txt"   // *C*hangeSet
//let BatchCommands = "batch_normal_FromTsvIntake_it.txt"

// (*) TSV residual updates (files without submitted translations)
//let BatchSubdir = "batch_normal"
//let BatchCommands = "batch_normal_FromTsvResidual.txt"

// (*) XML Android Migration (not yet translated for Apple devices)
//let BatchSubdir = "batch_normal"
//let BatchCommands = "batch_normal_FromXmlDroidOnly.txt"
//let BatchCommands = "batch_normal_FromXmlOnly_it.txt"

print("### \(BatchCommands) ###")

// …/AppLocalizerLibTests.bundle/Resources/commands_*.txt
// Content: batch commands file
///…/Debug/AppLocalizerLib_AppLocalizerLib.bundle/Contents/Resources/BatchCommands
var commandsDir = productsDir
    .appendingPathComponent("AppLocalizerLib_AppLocalizerLib.bundle")
    .appendingPathComponent("Contents", isDirectory: true)
    .appendingPathComponent("Resources", isDirectory: true)
    .appendingPathComponent("BatchCommands", isDirectory: true)
if BatchSubdir.isEmpty == false {
    commandsDir.appendPathComponent(BatchSubdir, isDirectory: true)
}
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
