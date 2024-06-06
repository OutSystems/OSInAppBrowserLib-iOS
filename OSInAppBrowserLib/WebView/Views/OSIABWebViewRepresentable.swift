import SwiftUI
import WebKit

struct OSIABWebViewRepresentable: UIViewRepresentable {
    private let webView: WKWebView
    
    init(_ webView: WKWebView) {
        self.webView = webView
    }
    
    func makeUIView(context: Context) -> WKWebView {
        self.webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Empty method.
        // This is required by the protocol.
    }
}
