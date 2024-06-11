import SwiftUI

/// Adapter that makes the required calls so that an `WKWebView` implementation can perform the Web View routing.
/// This is done via a customisable interface.
public class OSIABWebViewRouterAdapter: NSObject, OSIABRouter {
    public typealias ReturnType = UIViewController
    
    /// Object that contains the value to format the visual presentation.
    private let options: OSIABWebViewOptions
    /// Object that manages the browser's cache
    private let cacheManager: OSIABCacheManager
    /// Object that manages all the callbacks available for the WebView.
    private let callbackHandler: OSIABWebViewCallbackHandler
    
    /// Constructor method.
    /// - Parameters:
    ///   - options: Object that contains the value to format the visual presentation.
    ///   - cacheManager: Object that manages the browser's cache
    ///   - callbackHandler: Object that manages all the callbacks available for the WebView.
    public init(
        _ options: OSIABWebViewOptions,
        cacheManager: OSIABCacheManager,
        callbackHandler: OSIABWebViewCallbackHandler
    ) {
        self.options = options
        self.cacheManager = cacheManager
        self.callbackHandler = callbackHandler
    }
        
    public func handleOpen(_ url: URL, _ completionHandler: @escaping (ReturnType) -> Void) {
        if self.options.clearCache {
            self.cacheManager.clearCache()
        } else if self.options.clearSessionCache {
            self.cacheManager.clearSessionCache()
        }
        
        let viewModel = OSIABWebViewModel(
            url: url,
            self.options.mediaTypesRequiringUserActionForPlayback,
            self.options.enableViewportScale,
            self.options.allowInLineMediaPlayback,
            self.options.surpressIncrementalRendering,
            self.options.allowOverScroll,
            self.options.customUserAgent,
            closeButtonText: self.options.closeButtonText,
            callbackHandler: self.callbackHandler
        )
        let hostingController = UIHostingController(rootView: OSIABWebViewWrapper(viewModel))
        hostingController.modalPresentationStyle = self.options.modalPresentationStyle
        hostingController.modalTransitionStyle = self.options.modalTransitionStyle
        hostingController.presentationController?.delegate = self
        
        completionHandler(hostingController)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate implementation
extension OSIABWebViewRouterAdapter: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.callbackHandler.onBrowserClosed(true)
    }
}
