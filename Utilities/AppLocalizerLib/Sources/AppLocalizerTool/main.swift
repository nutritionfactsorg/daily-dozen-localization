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

// batch_replicate_DroidToTSV.yaml
// batch_replicate_TsvToApple.yaml

// batch_diff_xliff.yaml
// batch_diff_tsv_update_af.yaml
// batch_diff_tsv_update__all.yaml
// batch_export_es.yaml
// batch_export_pl_es.yaml
// batch_import_es.yaml
// batch_import_pl.yaml
// batch_import_de.yaml: de, pl

// :NOTES: batch_export_pass01 vs batch_replicate_DroidToTsv
// batch_export_pass01.yaml
// batch_replicate_DroidToTsv.yaml
// "batch_replicate_TsvToApple.yaml" // :WIP: for test version

// ::WIP::
// ___ Check en_US baseline: batch_diff_tsv_enUS.yaml

// ::WIP:: Normalize

// (TEST)
//let BatchSubdir = "batch_normal"
//let batchCommands = "batch_normal_FromTsvTest.yaml"

// (0) XLIFF use to review current App keywords to lang repo
// -- NORMALIZE: repo xliff -> strings
//let BatchSubdir = "batch_normal"
//let batchCommands = "batch_normal_FromXliff.yaml"

// (1) TSV MAIN REPO ("truth") to "NORMALIZED" product files 
// -- Generated normalized `*.tsv`, `*.json`, `*.string`, `*.xml`
// -- Manually verify/sync normalized English results to existing App English files.
// -- Rerun, and repeat verify/sync until English main repo is fully up to date.
// -- Compare normalized English-Language tsv keywords. Updates as needed.
//let BatchSubdir = "batch_normal"
//let batchCommands = "batch_normal_FromTsvMain.yaml"
//let batchCommands = "batch_normal_FromTsvMain_es.yaml" // update spanish

// (2) TSV INTAKE to "NORMALIZED" .tsv, .json, .string, .xml  
// -- INTAKE: include/exclude languages as needed
// -- Compare/Update main repo with normalized intake tsv
// -- Compare/Propagate intake/main result with app files (localization, android, ios)

// (*) TSV residual updates (files without submitted translations)
//let BatchSubdir = "batch_normal"
//let batchCommands = "batch_normal_FromTsvResidual.yaml"

// (*) XML Android Migration (not yet translated for Apple devices)
//let BatchSubdir = "batch_normal"
//let batchCommands = "batch_normal_FromXmlDroidOnly.yaml"
//let batchCommands = "batch_normal_FromXmlOnly_it.yaml"

let BatchSubdir = "batch_normal"
//let batchCommands = "batch_normal_intake__bg.yaml"
//let batchCommands = "batch_normal_intake__de_v05.yaml"
//let batchCommands = "batch_normal_intake__fa_v05.yaml" // Persian
//let batchCommands = "batch_normal_intake__it_v03.yaml"
//let batchCommands = "batch_normal_intake__fr_v04.yaml"
//let batchCommands = "batch_normal_intake__mk_v05.yaml"
//let batchCommands = "batch_normal_intake__ro.yaml"
//let batchCommands = "batch_normal_intake__uk_v05.yaml" // Ukrainian
//let batchCommands = "batch_normal_intake__zh_v05.yaml"
//let batchCommands = "batch_normal_intake_B.yaml"        // *B*aseline
//let batchCommands = "batch_normal_intake_C.yaml"        // *C*hangeSet
//let batchCommands = "batch_normal_intake_C_1.yaml"      // *C*hangeSet01
//let batchCommands = "batch_normal_intake_C_2.yaml"      // *C*hangeSet02
//let batchCommands = "batch_normal_intake_C_3.yaml"      // *C*hangeSet03
//let batchCommands = "batch_normal_intake+BC.yaml"       // *B*aseline + *C*hangeSet
//let batchCommands = "batch_normal_intake+BC_1…4.yaml"   // *B*aseline + *C*hangeSet
//let batchCommands = "batch_normal_intake+I_5.yaml"      // *I*nset

let batchCommands = "batch_normal_intake+BC_5.yaml"     // last step (aka after inset)

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
