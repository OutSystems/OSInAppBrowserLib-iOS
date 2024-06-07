import SafariServices

/// Adapter that makes the required calls so that an `SFSafariVieWController` implementation can perform the System Browser routing.
public class OSIABSafariViewControllerRouterAdapter: NSObject, OSIABRouter {
    public typealias ReturnType = UIViewController
    
    /// Object that contains the value to format the visual presentation.
    private let options: OSIABSystemBrowserOptions
    /// Callback to trigger when the initial page load is performed.
    private let onBrowserPageLoad: () -> Void
    /// Callback to trigger when the browser is closed.
    private let onBrowserClosed: () -> Void
    
    /// Constructor method.
    /// - Parameters:
    ///   - options: Object that contains the value to format the visual presentation.
    ///   - onBrowserPageLoad: Callback to trigger when the initial page load is performed.
    ///   - onBrowserClosed: Callback to trigger when the browser is closed.
    public init(_ options: OSIABSystemBrowserOptions, onBrowserPageLoad: @escaping () -> Void, onBrowserClosed: @escaping () -> Void) {
        self.options = options
        self.onBrowserPageLoad = onBrowserPageLoad
        self.onBrowserClosed = onBrowserClosed
    }
    
    public func handleOpen(_ url: URL, _ completionHandler: @escaping (ReturnType) -> Void) {
        let configurations = SFSafariViewController.Configuration()
        configurations.barCollapsingEnabled = self.options.enableBarsCollapsing
        configurations.entersReaderIfAvailable =  self.options.enableReadersMode
        
        let safariViewController = SFSafariViewController(url: url, configuration: configurations)
        safariViewController.dismissButtonStyle = self.options.dismissButtonStyle
        safariViewController.modalPresentationStyle = self.options.modalPresentationStyle
        safariViewController.modalTransitionStyle = self.options.modalTransitionStyle
        // delegates to perform the configured callbacks.
        safariViewController.delegate = self
        safariViewController.presentationController?.delegate = self
        
        completionHandler(safariViewController)
    }
}

// MARK: - SFSafariViewControllerDelegate implementation
extension OSIABSafariViewControllerRouterAdapter: SFSafariViewControllerDelegate {
    public func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully {
            self.onBrowserPageLoad()
        }
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.onBrowserClosed()
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate implementation
extension OSIABSafariViewControllerRouterAdapter: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.onBrowserClosed()
    }
}
