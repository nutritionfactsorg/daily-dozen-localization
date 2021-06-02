import Foundation
import UrlCheckLib

showEnvironment()
print(":MAIN: Bundle.moduleDir=\(Bundle.module)")
print(":MAIN: Bundle.moduleDir=\(Bundle.resourceModuleDir)")


let tool = UrlCheck()

do {
    try tool.run()
    exit(EXIT_SUCCESS)
} catch {
    print("UrlCheckLib tool.run() error: '\(error)'")
    exit(EXIT_FAILURE)
}

