import UIKit

public protocol OSIABApplicationDelegate: AnyObject {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?)
}

extension OSIABApplicationDelegate {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:], completionHandler completion: ((Bool) -> Void)?) {
        self.open(url, options: options, completionHandler: completion)
    }
}

extension UIApplication: OSIABApplicationDelegate {}

public class OSIABApplicationRouterAdapter: OSIABRouter {
    public typealias ReturnType = Bool
    
    private let application: OSIABApplicationDelegate
    
    public init(_ application: OSIABApplicationDelegate) {
        self.application = application
    }
    
    public func handleOpen(_ urlString: String, dismissStyle: OSIABDismissStyle, viewStyle: OSIABViewStyle, animation: OSIABAnimation, enableBarsCollapsing: Bool, _ completionHandler: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString), self.application.canOpenURL(url) else { return completionHandler(false) }
        self.application.open(url, completionHandler: completionHandler)
    }
}
