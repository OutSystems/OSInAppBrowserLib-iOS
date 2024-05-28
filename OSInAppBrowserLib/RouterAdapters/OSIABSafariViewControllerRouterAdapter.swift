import SafariServices

public class OSIABSafariViewControllerRouterAdapter: NSObject, OSIABRouter {
    public typealias ReturnType = UIViewController?
    public typealias Options = OSIABSystemBrowserOptions
    
    private let options: OSIABSystemBrowserOptions
    private let onBrowserPageLoad: () -> Void
    private let onBrowserClosed: () -> Void
    
    public init(_ options: OSIABSystemBrowserOptions, onBrowserPageLoad: @escaping () -> Void, onBrowserClosed: @escaping () -> Void) {
        self.options = options
        self.onBrowserPageLoad = onBrowserPageLoad
        self.onBrowserClosed = onBrowserClosed
    }
    
    public func handleOpen(_ urlString: String, _ completionHandler: @escaping (ReturnType) -> Void) {
        guard let url = URL(string: urlString) else { return completionHandler(nil) }
        
        let configurations = SFSafariViewController.Configuration()
        configurations.barCollapsingEnabled = self.options.enableBarsCollapsing
        configurations.entersReaderIfAvailable =  self.options.enableReadersMode
        
        let safariViewController = SFSafariViewController(url: url, configuration: configurations)
        safariViewController.dismissButtonStyle = self.options.dismissButtonStyle
        safariViewController.modalPresentationStyle = self.options.modalPresentationStyle
        safariViewController.modalTransitionStyle = self.options.modalTransitionStyle
        safariViewController.delegate = self
        safariViewController.presentationController?.delegate = self
        
        completionHandler(safariViewController)
    }
}

extension OSIABSafariViewControllerRouterAdapter: SFSafariViewControllerDelegate {
    public func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully { self.onBrowserPageLoad() }
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.onBrowserClosed()
    }
}

extension OSIABSafariViewControllerRouterAdapter: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.onBrowserClosed()
    }
}
