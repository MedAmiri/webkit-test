import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        
        // Inject JS that overrides console.log
        let js = """
        (function() {
            const oldLog = console.log;
            console.log = function(message) {
                window.webkit.messageHandlers.consoleLogger.postMessage("LOG: " + message);
                oldLog.apply(console, arguments);
            };
            const oldError = console.error;
            console.error = function(message) {
                window.webkit.messageHandlers.consoleLogger.postMessage("ERROR: " + message);
                oldError.apply(console, arguments);
            };
        })();
        """
        let script = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        contentController.addUserScript(script)
        contentController.add(context.coordinator, name: "consoleLogger")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No update needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}
    
class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

    // Capture console.log messages here
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        if message.name == "consoleLogger", let body = message.body as? String {
            print("[WebView Console] \(body)")
        }
    }

    // Support for window.open()
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
