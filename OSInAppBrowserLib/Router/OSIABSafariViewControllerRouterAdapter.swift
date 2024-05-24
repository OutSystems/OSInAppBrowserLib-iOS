import SafariServices

public struct OSIABSafariViewControllerRouterAdapter: OSIABRouter {
    public init() {}
    
    public func handleOpen(_ urlString: String, _ completionHandler: @escaping (UIViewController?) -> Void) {
        guard let url = URL(string: urlString) else { return completionHandler(nil) }
        completionHandler(SFSafariViewController(url: url))
    }
}
