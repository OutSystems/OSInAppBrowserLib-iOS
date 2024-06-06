import OSInAppBrowserLib
import UIKit

struct OSIABExternalRouterSpy: OSIABRouter {
    var shouldOpenSafari: Bool
    
    init(shouldOpenSafari: Bool) {
        self.shouldOpenSafari = shouldOpenSafari
    }
    
    func handleOpen(_ url: String, _ completionHandler: @escaping (Bool) -> Void) {
        completionHandler(shouldOpenSafari)
    }
}

struct OSIABSystemRouterSpy: OSIABRouter {
    var shouldOpenSafariViewController: UIViewController?
    
    init(shouldOpen viewController: UIViewController?) {
        self.shouldOpenSafariViewController = viewController
    }
    
    func handleOpen(_ url: String, _ completionHandler: @escaping (UIViewController?) -> Void) {
        completionHandler(shouldOpenSafariViewController)
    }
}

struct OSIABWebViewRouterSpy: OSIABRouter {
    var shouldOpenView: UIViewController?
    
    init(shouldOpen viewController: UIViewController? = nil) {
        self.shouldOpenView = viewController
    }
    
    func handleOpen(_ url: String, _ completionHandler: @escaping (UIViewController?) -> Void) {
        completionHandler(shouldOpenView)
    }
}
