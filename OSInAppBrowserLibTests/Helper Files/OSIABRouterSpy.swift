import OSInAppBrowserLib
import UIKit

struct OSIABExternalRouterSpy: OSIABRouter {
    var shouldOpenSafari: Bool
    
    init(shouldOpenSafari: Bool) {
        self.shouldOpenSafari = shouldOpenSafari
    }
    
    func handleOpen(_ url: String, dismissStyle: OSIABDismissStyle, viewStyle: OSIABViewStyle, animation: OSIABAnimation, _ completionHandler: @escaping (Bool) -> Void) {
        completionHandler(shouldOpenSafari)
    }
}

struct OSIABSystemRouterSpy: OSIABRouter {
    var shouldOpenSafariViewController: UIViewController?
    
    init(shouldOpen viewController: UIViewController?) {
        self.shouldOpenSafariViewController = viewController
    }
    
    func handleOpen(_ url: String, dismissStyle: OSIABDismissStyle, viewStyle: OSIABViewStyle, animation: OSIABAnimation, _ completionHandler: @escaping (UIViewController?) -> Void) {
        completionHandler(shouldOpenSafariViewController)
    }
}
