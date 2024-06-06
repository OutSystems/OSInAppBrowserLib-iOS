import SwiftUI

public class OSIABWebViewRouterAdapter: NSObject, OSIABRouter {
    public typealias ReturnType = UIViewController?
    
    private let options: OSIABWebViewOptions
    private let cacheManager: OSIABCacheManager
    
    private let onDelegateURL: (URL) -> Void
    private let onDelegateAlertController: (UIAlertController) -> Void
    private let onBrowserPageLoad: () -> Void
    private let onBrowserClosed: (Bool) -> Void
    
    public init(
        _ options: OSIABWebViewOptions,
        cacheManager: OSIABCacheManager,
        onDelegateURL: @escaping (URL) -> Void,
        onDelegateAlertController: @escaping (UIAlertController) -> Void,
        onBrowserPageLoad: @escaping () -> Void,
        onBrowserClosed: @escaping (Bool) -> Void // boolean indicates if the browser is already closed.
    ) {
        self.options = options
        self.cacheManager = cacheManager
        self.onDelegateURL = onDelegateURL
        self.onDelegateAlertController = onDelegateAlertController
        self.onBrowserPageLoad = onBrowserPageLoad
        self.onBrowserClosed = onBrowserClosed
    }
        
    public func handleOpen(_ urlString: String, _ completionHandler: @escaping (ReturnType) -> Void) {
        guard let url = URL(string: urlString) else { return completionHandler(nil) }
        
        if self.options.clearCache {
            self.cacheManager.clearCache()
        } else if self.options.clearSessionCache {
            self.cacheManager.clearSessionCache()
        }
        
        let webViewCallbackHandler = OSIABWebViewCallbackHandler(
            self.onDelegateURL, self.onDelegateAlertController, self.onBrowserPageLoad, onBrowserClosed: { self.onBrowserClosed(false) }
        )
        let viewModel = OSIABWebViewModel(
            url: url,
            self.options.mediaTypesRequiringUserActionForPlayback,
            self.options.enableViewportScale,
            self.options.allowInLineMediaPlayback,
            self.options.surpressIncrementalRendering,
            self.options.allowOverScroll,
            self.options.closeButtonText,
            callbackHandler: webViewCallbackHandler
        )
        let hostingController = UIHostingController(rootView: OSIABWebViewWrapper(viewModel))
        hostingController.modalPresentationStyle = self.options.modalPresentationStyle
        hostingController.modalTransitionStyle = self.options.modalTransitionStyle
        hostingController.presentationController?.delegate = self
        
        completionHandler(hostingController)
    }
}

extension OSIABWebViewRouterAdapter: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.onBrowserClosed(true)
    }
}
