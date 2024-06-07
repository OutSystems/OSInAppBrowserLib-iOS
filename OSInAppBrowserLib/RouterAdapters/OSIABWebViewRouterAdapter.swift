import SwiftUI

public class OSIABWebViewRouterAdapter: NSObject, OSIABRouter {
    public typealias ReturnType = UIViewController
    
    private let options: OSIABWebViewOptions
    private let cacheManager: OSIABCacheManager
    private let callbackHandler: OSIABWebViewCallbackHandler
    
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

extension OSIABWebViewRouterAdapter: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.callbackHandler.onBrowserClosed(true)
    }
}
