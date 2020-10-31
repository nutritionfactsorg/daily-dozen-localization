import Foundation
import AppLocalizerLib

#if DEBUG
//print(getEnvironment())
#endif

var productsDirMain: URL = Bundle.main.bundleURL
print("productsDirMain='\(productsDirMain)'")

var workingExecDir: URL!  // …/Debug/ or 
var workingMapDir: URL!   // AppLocalizerLib.bundle contains TSV mappings

var workingDataDir: URL!  // Languages/*/android XML and /ios/*.xcloc/..

workingExecDir = productsDirMain
workingDataDir = productsDirMain
    .appendingPathComponent("AppLocalizerData.bundle")
    .appendingPathComponent("Resources", isDirectory: true)
workingDataDir = productsDirMain
    .appendingPathComponent("AppLocalizerCmd.bundle")
    .appendingPathComponent("Resources", isDirectory: true)
workingDataDir = productsDirMain
    .appendingPathComponent("AppLocalizerMap.bundle")
    .appendingPathComponent("Resources", isDirectory: true)

for language in BatchJob.Language.allCases {
    //let language = BatchJob.Language.es
    let job = BatchJob(workingDataDir: workingDataDir, language: language)
    let tool = AppLocalizer(job: job)

    do {
        try tool.run()
        
    } catch {
        print("\n########################################")
        print(  "AppLocalizerLib tool.run() error:\n\(error)")
        exit(EXIT_FAILURE)
    }    
}
exit(EXIT_SUCCESS)
