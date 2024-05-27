import SafariServices

public struct OSIABSafariViewControllerRouterAdapter: OSIABRouter {
    public typealias ReturnType = UIViewController?
    public typealias Options = OSIABSystemBrowserOptions
    
    public init() {}
    
    public func handleOpen(_ urlString: String, _ options: Options = .init(), _ completionHandler: @escaping (ReturnType) -> Void) {
        guard let url = URL(string: urlString) else { return completionHandler(nil) }
        
        let configurations = SFSafariViewController.Configuration()
        configurations.barCollapsingEnabled = options.enableBarsCollapsing
        configurations.entersReaderIfAvailable = options.enableReadersMode
        
        let safariViewController = SFSafariViewController(url: url, configuration: configurations)
        safariViewController.dismissButtonStyle = options.dismissButtonStyle
        safariViewController.modalPresentationStyle = options.modalPresentationStyle
        safariViewController.modalTransitionStyle = options.modalTransitionStyle
        
        completionHandler(safariViewController)
    }
}
