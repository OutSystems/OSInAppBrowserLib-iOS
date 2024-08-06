import Combine
import WebKit

/// View Model containing all the WebView's customisations.
class OSIABWebViewModel: NSObject, ObservableObject {
    /// The WebView to display and configure.
    let webView: WKWebView
    /// Sets the text to display on the Close button.
    let closeButtonText: String
    /// Object that manages all the callbacks available for the WebView.
    private let callbackHandler: OSIABWebViewCallbackHandler
    
    /// Sets the position to display the Toolbar.
    let toolbarPosition: OSIABToolbarPosition?
    /// Indicates if the navigations should be displayed on the toolbar.
    let showNavigationButtons: Bool
    /// Indicates the positions of the navigation buttons and the close button - which one is on the left and on the right.
    let leftToRight: Bool
    
    /// Indicates if first load is already done. This is important in order to trigger the `browserPageLoad` event.
    private var firstLoadDone: Bool = false
    
    /// The current URL being displayed
    @Published private(set) var url: URL
    /// Indicates if the URL is being loaded into the screen.
    @Published private(set) var isLoading: Bool = true
    /// Indicates if there was any error while loading the URL.
    @Published private(set) var error: Error?
    /// Indicates if the back button is available for pressing.
    @Published private(set) var backButtonEnabled: Bool = true
    /// Indicates if the forward button is available for pressing.
    @Published private(set) var forwardButtonEnabled: Bool = true
    
    /// The current adress label being displayed on the screen. Empty string indicates that the address will not be displayed.
    @Published private(set) var addressLabel: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Constructor method.
    /// - Parameters:
    ///   - url: The current URL being displayed
    ///   - webViewConfiguration: Collection of properties with which to initialize the WebView.
    ///   - scrollViewBounces: Indicates if the WebView's bounce property should be enabled. Defaults to `true`.
    ///   - customUserAgent: Sets a custom user agent for the WebView.
    ///   - uiModel: Collection of properties to apply to the WebView's interface.
    ///   - callbackHandler: Object that manages all the callbacks available for the WebView.
    init(
        url: URL,
        _ webViewConfiguration: WKWebViewConfiguration,
        _ scrollViewBounces: Bool = true,
        _ customUserAgent: String? = nil,
        uiModel: OSIABWebViewUIModel,
        callbackHandler: OSIABWebViewCallbackHandler
    ) {
        self.url = url
        self.webView = .init(frame: .zero, configuration: webViewConfiguration)
        self.closeButtonText = uiModel.closeButtonText
        self.callbackHandler = callbackHandler
        if uiModel.showToolbar {
            self.toolbarPosition = uiModel.toolbarPosition
            if uiModel.showURL {
                self.addressLabel = url.absoluteString
            }
        } else {
            self.toolbarPosition = nil
        }
        self.showNavigationButtons = uiModel.showNavigationButtons
        self.leftToRight = uiModel.leftToRight
        
        super.init()
        
        self.webView.scrollView.bounces = scrollViewBounces
        self.webView.customUserAgent = customUserAgent
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        
        self.setupBindings(uiModel.showURL, uiModel.showToolbar, uiModel.showNavigationButtons)
    }
    
    /// Setups the combine bindings, so that the Published properties can be filled automatically and reactively.
    private func setupBindings(_ showURL: Bool, _ showToolbar: Bool, _ showNavigationButtons: Bool) {
        if #available(iOS 14.0, *) {
            self.webView.publisher(for: \.isLoading)
                .assign(to: &$isLoading)
            
            self.webView.publisher(for: \.url)
                .compactMap { $0 }
                .assign(to: &$url)
            
            if showToolbar {
                if showNavigationButtons {
                    self.webView.publisher(for: \.canGoBack)
                        .assign(to: &$backButtonEnabled)
                    
                    self.webView.publisher(for: \.canGoForward)
                        .assign(to: &$forwardButtonEnabled)
                }
                
                if showURL {
                    self.$url.map(\.absoluteString)
                        .assign(to: &$addressLabel)
                }
            }
        } else {
            self.webView.publisher(for: \.isLoading)
                .assign(to: \.isLoading, on: self)
                .store(in: &cancellables)
            
            self.webView.publisher(for: \.url)
                .compactMap { $0 }
                .assign(to: \.url, on: self)
                .store(in: &cancellables)
            
            if showToolbar {
                if showNavigationButtons {
                    self.webView.publisher(for: \.canGoBack)
                        .assign(to: \.backButtonEnabled, on: self)
                        .store(in: &cancellables)
                    
                    self.webView.publisher(for: \.canGoForward)
                        .assign(to: \.forwardButtonEnabled, on: self)
                        .store(in: &cancellables)
                }
                
                if showURL {
                    self.$url.map(\.absoluteString)
                        .assign(to: \.addressLabel, on: self)
                        .store(in: &cancellables)
                }
            }
        }
    }
    
    /// Loads the URL within the WebView. Is the first operation to be performed when the view is displayed.
    func loadURL() {
        self.webView.load(.init(url: self.url))
    }
    
    /// Signals the WebView to move forward. This is performed as a reaction to a button click.
    func forwardButtonPressed() {
        self.webView.goForward()
    }
    
    /// Signals the WebView to move backwards. This is performed as a reaction to a button click.
    func backButtonPressed() {
        self.webView.goBack()
    }
    
    /// Signals the WebView to be closed, triggering the `browserClosed` event. This is performed as a reaction to a button click.
    func closeButtonPressed() {
        self.callbackHandler.onBrowserClosed(false)
    }
}

// MARK: - WKNavigationDelegate implementation
extension OSIABWebViewModel: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var shouldStart = true
        
        guard let url = navigationAction.request.url, url == navigationAction.request.mainDocumentURL else { return decisionHandler(.cancel) }
        
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
        error = nil
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

// MARK: - WKUIDelegate implementation
extension OSIABWebViewModel: WKUIDelegate {
    typealias ButtonHandler = (UIAlertController) -> Void
    
    /// Creates an `UIAlertController` instance with the passed information.
    /// - Parameters:
    ///   - message: Message to be displayed in the alert.
    ///   - okButtonHandler: Handler for the ok button click operation.
    ///   - cancelButtonHandler: Handler for the cancel button click operation. It's optional as this button is not always present.
    /// - Returns: The created `UIAlertController` instance.
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
