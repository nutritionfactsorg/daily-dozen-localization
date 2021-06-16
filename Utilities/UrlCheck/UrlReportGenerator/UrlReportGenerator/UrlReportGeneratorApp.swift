//
//  UrlReportGeneratorApp.swift
//  UrlReportGenerator
//

import SwiftUI

// Note: On macOS, set "Signing and Capabilities" > "Outgoing Connections (Client)" to true

@main
struct UrlReportGeneratorApp: App {
    
    init() {
        print("• @main UrlReportGeneratorApp App init")
        print(":BEGIN: \(Date().datestampyyyyMMddHHmmss) (approx 12 minutes)")
        UrlStatusCheck.shared.load()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
