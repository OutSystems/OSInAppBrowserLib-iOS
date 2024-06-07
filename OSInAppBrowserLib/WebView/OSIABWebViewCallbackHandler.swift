import UIKit

public struct OSIABWebViewCallbackHandler {
    let onDelegateURL: (URL) -> Void
    let onDelegateAlertController: (UIAlertController) -> Void
    let onBrowserPageLoad: () -> Void
    let onBrowserClosed: (Bool) -> Void
    
    public init(
        onDelegateURL: @escaping (URL) -> Void,
        onDelegateAlertController: @escaping (UIAlertController) -> Void,
        onBrowserPageLoad: @escaping () -> Void,
        onBrowserClosed: @escaping (Bool) -> Void // boolean indicates if the browser is already closed.
    ) {
        self.onDelegateURL = onDelegateURL
        self.onDelegateAlertController = onDelegateAlertController
        self.onBrowserPageLoad = onBrowserPageLoad
        self.onBrowserClosed = onBrowserClosed
    }
}
