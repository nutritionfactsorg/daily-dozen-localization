//
//  BundleExtensions.swift
//  UrlStatusCheckLib
//

import Foundation

extension Foundation.Bundle {

    /// Directory containing resource bundle
    static var resourceModuleDir: URL = {
        //print(":INFO: UrlStatusCheckLib resourceModuleDir ")
        var url = Bundle.main.bundleURL
        // :!!!: verify resourceModuleDir logic
        for bundle in Bundle.allBundles {
            //print("   … found \(bundle)")
            if bundle.bundlePath.hasSuffix(".xctest") {
                // remove 'ExecutableNameTests.xctest' path component
                url = bundle.bundleURL.deletingLastPathComponent()
            }
        }
        return url
    }()
    
}
