import WebKit

class OSIABWebViewModel: NSObject, ObservableObject {
    let webView: WKWebView
    let closeButtonText: String
    private let callbackHandler: OSIABWebViewCallbackHandler
    
    private var firstLoadDone: Bool = false
    
    @Published private var url: URL
    
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var error: Error?
    @Published private(set) var backButtonEnabled: Bool = true
    @Published private(set) var forwardButtonEnabled: Bool = true
    
    @Published private(set) var addressLabel: String
    
    init(
        url: URL,
        _ mediaTypesRequiringUserActionForPlayback: WKAudiovisualMediaTypes = [],
        _ ignoresViewportScaleLimits: Bool = false,
        _ allowsInlineMediaPlayback: Bool = false,
        _ suppressesIncrementalRendering: Bool = false,
        _ scrollViewBounces: Bool = false,
        _ customUserAgent: String? = nil,
        closeButtonText: String = "Close",
        callbackHandler: OSIABWebViewCallbackHandler
    ) {
        let configuration = WKWebViewConfiguration()
        configuration.mediaTypesRequiringUserActionForPlayback = mediaTypesRequiringUserActionForPlayback
        configuration.ignoresViewportScaleLimits = ignoresViewportScaleLimits
        configuration.allowsInlineMediaPlayback = allowsInlineMediaPlayback
        configuration.suppressesIncrementalRendering = suppressesIncrementalRendering
        
        self.url = url
        self.webView = .init(frame: .zero, configuration: configuration)
        self.closeButtonText = closeButtonText
        self.callbackHandler = callbackHandler
        self.addressLabel = url.absoluteString
        
        super.init()
        
        self.webView.scrollView.bounces = scrollViewBounces
        self.webView.customUserAgent = customUserAgent
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        setupBindings()
    }
    
    private func setupBindings() {
        self.webView.publisher(for: \.isLoading)
            .assign(to: &$isLoading)
        
        self.webView.publisher(for: \.canGoBack)
            .assign(to: &$backButtonEnabled)
        
        self.webView.publisher(for: \.canGoForward)
            .assign(to: &$forwardButtonEnabled)
        
        self.webView.publisher(for: \.url)
            .compactMap { $0 }
            .map(\.absoluteString)
            .assign(to: &$addressLabel)
    }
    
    func loadURL() {
        self.webView.load(.init(url: self.url))
    }
    
    func forwardButtonPressed() {
        self.webView.goForward()
    }
    
    func backButtonPressed() {
        self.webView.goBack()
    }
    
    func closeButtonPressed() {
        self.callbackHandler.onBrowserClosed(false)
    }
}

extension OSIABWebViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var shouldStart = true
        
        guard let url = navigationAction.request.url, url == navigationAction.request.mainDocumentURL else { return decisionHandler(.cancel) }
        self.url = url
        
        // if is an app store, tel, sms, mailto or geo link, let the system handle it, otherwise it fails to load it
        if ["itms-appss", "itms-apps", "tel", "sms", "mailto", "geo"].contains(url.scheme) {
            webView.stopLoading()
            self.callbackHandler.onDelegateURL(url)
            shouldStart = false
        }
        
        if shouldStart {
            if navigationAction.targetFrame != nil {
                decisionHandler(.allow)
            } else {
                webView.load(navigationAction.request)
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !self.firstLoadDone {
            self.callbackHandler.onBrowserPageLoad()
            self.firstLoadDone = true
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.webView(webView, didFailedNavigation: "didFailNavigation", with: error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.webView(webView, didFailedNavigation: "didFailProvisionalNavigation", with: error)
    }
    
    private func webView(_ webView: WKWebView, didFailedNavigation delegateName: String, with error: Error) {
        print("webView: \(delegateName) - \(error.localizedDescription)")
        if (error as NSError).code != NSURLErrorCancelled {
            self.error = error
        }
    }
}

extension OSIABWebViewModel: WKUIDelegate {
    typealias ButtonHandler = (UIAlertController) -> Void
    
    private func createAlertController(withBodyText message: String, okButtonHandler: @escaping ButtonHandler, cancelButtonHandler: ButtonHandler? = nil) -> UIAlertController {
        let title = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            okButtonHandler(alert)
        }
        alert.addAction(okAction)
        
        if let cancelButtonHandler {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                cancelButtonHandler(alert)
            }
            alert.addAction(cancelAction)
        }
        
        return alert
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let result = self.createAlertController(
            withBodyText: message,
            okButtonHandler: { alert in
                completionHandler()
                alert.dismiss(animated: true)
            }
        )
        self.callbackHandler.onDelegateAlertController(result)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let handler: (UIAlertController, Bool) -> Void = { alert, input in
            completionHandler(input)
            alert.dismiss(animated: true)
        }
        
        let result = self.createAlertController(
            withBodyText: message,
            okButtonHandler: { handler($0, true) },
            cancelButtonHandler: { handler($0, false) }
        )
        self.callbackHandler.onDelegateAlertController(result)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let handler: (UIAlertController, Bool) -> Void = { alert, returnTextField in
            completionHandler(returnTextField ? alert.textFields?.first?.text : nil)
            alert.dismiss(animated: true)
        }
        
        let result = self.createAlertController(
            withBodyText: prompt,
            okButtonHandler: { handler($0, true) },
            cancelButtonHandler: { handler($0, false) }
        )
        result.addTextField { $0.text = defaultText }
        self.callbackHandler.onDelegateAlertController(result)
    }
}
