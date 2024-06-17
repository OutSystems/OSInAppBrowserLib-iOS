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
            self.options.toConfigurationModel().toWebViewConfiguration(),
            self.options.allowOverScroll,
            self.options.customUserAgent,
            uiModel: self.options.toUIModel(),
            callbackHandler: self.callbackHandler
        )
        
        let hostingController = OSIABWebViewController(rootView: .init(viewModel), dismiss: { self.callbackHandler.onBrowserClosed(true) })
        hostingController.modalPresentationStyle = self.options.modalPresentationStyle
        hostingController.modalTransitionStyle = self.options.modalTransitionStyle
        hostingController.presentationController?.delegate = self
        
        completionHandler(hostingController)
    }
}

private extension OSIABWebViewOptions {
    func toConfigurationModel() -> OSIABWebViewConfigurationModel {
        .init(
            self.mediaTypesRequiringUserActionForPlayback,
            self.enableViewportScale,
            self.allowInLineMediaPlayback,
            self.surpressIncrementalRendering
        )
    }
    
    func toUIModel() -> OSIABWebViewUIModel {
        .init(
            showURL: self.showURL,
            showToolbar: self.showToolbar,
            toolbarPosition: self.toolbarPosition,
            showNavigationButtons: self.showNavigationButtons,
            leftToRight: self.leftToRight,
            closeButtonText: self.closeButtonText
        )
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate implementation
extension OSIABWebViewRouterAdapter: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.callbackHandler.onBrowserClosed(true)
    }
}

private class OSIABWebViewController: UIHostingController<OSIABWebViewWrapper> {
    let dismiss: () -> Void
    
    init(rootView: OSIABWebViewWrapper, dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        self.dismiss = {
            // nothing to do here
        }
        super.init(coder: aDecoder)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: {
            self.dismiss()
            completion?()
        })
    }
}
