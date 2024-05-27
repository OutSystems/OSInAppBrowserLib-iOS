import UIKit

/// Structure responsible for managing all InAppBrowser interactions.
public struct OSIABEngine<ExternalBrowser: OSIABRouter, SystemBrowser: OSIABRouter>
where ExternalBrowser.ReturnType == Bool, SystemBrowser.ReturnType == UIViewController? {
    public init() {}
    
    /// Trigger the external browser to open the passed `url`.
    /// - Parameter url: URL to be opened.
    /// - Returns: Indicates if the operation was successful or not.
    public func openExternalBrowser(_ url: String, routerDelegate: ExternalBrowser, _ completionHandler: @escaping (ExternalBrowser.ReturnType) -> Void) {
        routerDelegate.handleOpen(url, completionHandler)
    }
    
    public func openSystemBrowser(
        _ url: String,
        routerDelegate: SystemBrowser,
        dismissStyle: OSIABDismissStyle = .defaultValue,
        viewStyle: OSIABViewStyle = .defaultValue,
        animation: OSIABAnimation = .defaultValue,
        enableBarsCollapsing: Bool = true,
        _ completionHandler: @escaping (SystemBrowser.ReturnType) -> Void
    ) {
        routerDelegate.handleOpen(
            url, dismissStyle: dismissStyle, viewStyle: viewStyle, animation: animation, enableBarsCollapsing: enableBarsCollapsing, completionHandler
        )
    }
}
