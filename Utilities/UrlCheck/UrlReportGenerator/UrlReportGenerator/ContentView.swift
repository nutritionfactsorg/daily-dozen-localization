//
//  ContentView.swift
//  UrlReportGenerator
//

import SwiftUI
import WebKit

struct ContentView: View {
    @ObservedObject var webViewStateModel: WebViewStateModel = WebViewStateModel()
    
    var body: some View {
        WebViewRepresentable(
            webviewStateModel: self.webViewStateModel)
    }
}

// ----- Preview -----

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
