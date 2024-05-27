import SafariServices

public struct OSIABSafariViewControllerRouterAdapter: OSIABRouter {
    public typealias ReturnType = UIViewController?
    
    public init() {}
    
    public func handleOpen(_ urlString: String, dismissStyle: OSIABDismissStyle, _ completionHandler: @escaping (ReturnType) -> Void) {
        guard let url = URL(string: urlString) else { return completionHandler(nil) }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.dismissButtonStyle = dismissStyle.toSFSafariViewControllerDismissButtonStyle()
        
        completionHandler(safariViewController)
    }
}
