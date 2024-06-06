import UIKit

struct OSIABWebViewCallbackHandler {
    let onDelegateURL: (URL) -> Void
    let onDelegateAlertController: (UIAlertController) -> Void
    let onBrowserPageLoad: () -> Void
    let onBrowserClosed: () -> Void
    
    init(
        _ onDelegateURL: @escaping (URL) -> Void,
        _ onDelegateAlertController: @escaping (UIAlertController) -> Void,
        _ onBrowserPageLoad: @escaping () -> Void,
        onBrowserClosed: @escaping () -> Void
    ) {
        self.onDelegateURL = onDelegateURL
        self.onDelegateAlertController = onDelegateAlertController
        self.onBrowserPageLoad = onBrowserPageLoad
        self.onBrowserClosed = onBrowserClosed
    }
}
