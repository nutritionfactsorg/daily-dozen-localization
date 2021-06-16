//
//  WebViewRepresentable.swift
//  UrlReportGenerator
//

import Foundation
import SwiftUI
import WebKit

class WebViewStateModel: ObservableObject {
    @Published var atIndex: Int = 0
}

// Note: WebViewRepresentable needs to be `class`. A `struct` does not call updateNSView.

final class WebViewRepresentable : NSViewRepresentable {
    
    /// webviewStateModel instantiated in ContentView
    @ObservedObject var webviewStateModel: WebViewStateModel
    let _checker = UrlStatusCheck.shared
    let coordinatorAction: ( () -> Void )?
    
    init(webviewStateModel: WebViewStateModel,
         coordinatorAction: ( () -> Void )? = nil
    ) {
        //print("•WVR++ WebViewRepresentable init")
        self.coordinatorAction = coordinatorAction
        self.webviewStateModel = webviewStateModel
    }

    //deinit {
    //    print("•WVR-- WebViewRepresentable deinit")
    //}
    
    /// Custom communication instance communicate changes from MyView to to other parts of the SwiftUI interface.
    ///
    /// * Not needed if view doesn't interact with other parts of the application.
    /// * called before `makeNSView(context:)`
    /// * The system provides the coordinator instance either directly or as part of a context.
    /// * `Coordinator` can be accessed via `Context` if public
    final class Coordinator: NSObject {
        @ObservedObject var __StateModel: WebViewStateModel
        let __checker = UrlStatusCheck.shared
        let coordinatorAction: ( () -> Void )?
        
        init(coordinatorAction: ( () -> Void )? = nil,
             webViewStateModel: WebViewStateModel) {
            print("•COOR• Coordinator init")
            self.coordinatorAction = coordinatorAction
            self.__StateModel = webViewStateModel
        }
    }

    func makeCoordinator() -> Coordinator {
        //print("•WVR•  WebViewRepresentable makeCoordinator")
        return Coordinator(webViewStateModel: webviewStateModel) // :???:action
    }
    
    /// Create a specified view object and configure its initial state based on the SwiftUI Context.
    func makeNSView(context: Context) -> WKWebView  {
        //print("•WVR•• WebViewRepresentable makeNSView")
        //let a: WebViewRepresentable.Coordinator = context.coordinator
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        config.applicationNameForUserAgent = "Firefox/89.0"
        config.suppressesIncrementalRendering = true
        config.allowsAirPlayForMediaPlayback = false
        config.mediaTypesRequiringUserActionForPlayback = .all
        let rect = CGRect(x: 0, y: 0, width: 850, height: 1100)
        let view = WKWebView(frame: rect, configuration: config)
        view.navigationDelegate = context.coordinator
        
        // first request
        let url = _checker.linkFirst()
        print("       url: \(url)")
        let urlRequest = URLRequest(
            url: url,
            cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData,
            timeoutInterval: TimeInterval(15.0) // seconds
        )
        view.load(urlRequest)
        return view
    }
    
    /// Update the specified view state from new SwiftUI Context information
    func updateNSView(_ uiView: WKWebView, context: Context) {
        //print("•WVR•  WebViewRepresentable updateNSView")
    }
    
}

extension WebViewRepresentable.Coordinator: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        //print("•>>    WKNavigationDelegate decidePolicyFor navigationResponse")
        if let response = navigationResponse.response as? HTTPURLResponse {
            let index = __StateModel.atIndex
            let statusCode = response.statusCode
            print("       @index \(index) [\(Int(index/2))] statusCode: \(statusCode)")
            __checker.updateStatus(index: index, statusCode: statusCode)
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //print("•>>>   WKNavigationDelegate didFinish navigation")
        webView.createWebArchiveData { (result: Result<Data, Error>) in
            print("    >> \(webView.url?.absoluteString ?? "nil_url")")
            let index = self.__StateModel.atIndex
            switch result {
            case .success(let data):
                let processor = WebContentProcessor.shared
                if index % 2 == 0 {
                    if let count = processor.querySearchCount(webarchive: data) {
                        self.__checker.updateCount(index: index, count: count)
                        print("       @index \(index) [\(Int(index/2))] count: \(count)")
                    } else {
                        if let itemName = self.__checker.item(index: index) {
                            self.__checker.writeWebArchive(index: index, name: itemName, data: data)
                        }
                    }
                } else {
                    if let code = self.__checker.code(index: index) {
                        if code == 404 {
                            self.__checker.append404(index: index)
                        } else if code == 200 {
                            if let count = processor.queryTopicCount(webarchive: data) {
                                self.__checker.updateCount(index: index, count: count)
                                print("       @index \(index) [\(Int(index/2))] count: \(count)")
                            } else {
                                if let itemName = self.__checker.item(index: index) {
                                    self.__checker.writeWebArchive(index: index, name: itemName, data: data)
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print("       @index \(index) [\(Int(index/2))] count-error: \(error)")
            }
            
            // ----- next url ------
            if let next = self.__checker.linkNext(index: index) {
                let urlRequest = URLRequest(
                    url: next.url,
                    cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                    timeoutInterval: TimeInterval(15.0) // seconds
                )
                webView.load(urlRequest)
                self.__StateModel.atIndex = next.index
                //print("       @index \(self.__StateModel.atIndex) [NEXT] \(next.url.absoluteString)")
            } else {
                self.__checker.writeReport()
                print(":END: \(Date().datestampyyyyMMddHHmmss)")
            }
        } // END: createWebArchiveData
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("•>>>   WKNavigationDelegate didFail navigation :FAIL:")
    }
    
}
