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
    for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
        return bundle.bundleURL.deletingLastPathComponent()
    }
    fatalError(":ERROR:TEST: build products directory `productsDir` not found")
    #else
    return Bundle.main.bundleURL
    #endif
}

// :NYI: support `commandSet` as parameter. check for default file is no parameter.
let commandSet = "commands_import_pl.txt"

// …/AppLocalizerLibTests.bundle/Resources/commands_*.txt
// Content: batch commands file
let commandsDir = productsDir
    .appendingPathComponent("AppLocalizerLibTests.bundle")
    .appendingPathComponent("Resources", isDirectory: true)
let commandsFile = commandsDir
    .appendingPathComponent(commandSet, isDirectory: false)
print("commandsDir=\(commandsDir.absoluteString)")
print("commandsFile=\(commandsFile.absoluteString)")

// …/AppLocalizerLibTests.bundle/Languages/ 
// copy from daily-dozen-localization/Languages
//  e.g. Languages/Spanish/android/, …ios/, …tsv/
let languagesDir = productsDir
    .appendingPathComponent("AppLocalizerLibTests.bundle")
    .appendingPathComponent("Languages", isDirectory: true)
print("languagesDir=\(languagesDir.absoluteString)")

// …/AppLocalizerLib.bundle/Resources/ …Doze/ and …Tweak/
// Content: Android <--> Apple mapping files 
let mappingsDir = productsDir
    .appendingPathComponent("AppLocalizerLib.bundle")
    .appendingPathComponent("Resources", isDirectory: true)
print("mappingsDir=\(mappingsDir.absoluteString)")

let appLocalizer = AppLocalizer()
appLocalizer.run(commandsUrl: commandsFile, languagesUrl: languagesDir, mappingsUrl: mappingsDir)

exit(EXIT_SUCCESS)
