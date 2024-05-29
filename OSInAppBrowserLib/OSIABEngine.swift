import UIKit

/// Structure responsible for managing all InAppBrowser interactions.
public struct OSIABEngine<ExternalBrowser: OSIABRouter, SystemBrowser: OSIABRouter>
where ExternalBrowser.ReturnType == Bool, SystemBrowser.ReturnType == UIViewController? {
    /// Constructor method.
    public init() {
        // Empty constructor
        // This is required for the library's callers.
    }
    
    /// Delegates opening the passed `url`to the External Browser.
    /// - Parameter url: URL to be opened.
    /// - Parameter routerDelegate: The External Browser that will open the url.`
    /// - Parameter completionHandler: The callback with the result of opening the url using the External Browser.
    public func openExternalBrowser(_ url: String, routerDelegate: ExternalBrowser, _ completionHandler: @escaping (ExternalBrowser.ReturnType) -> Void) {
        routerDelegate.handleOpen(url, completionHandler)
    }
    
    /// Delegates opening the passed `url`to the System Browser.
    /// - Parameter url: URL to be opened.
    /// - Parameter routerDelegate: The System Browser that will open the url.`
    /// - Parameter completionHandler: The callback with the result of opening the url using the System Browser.
    public func openSystemBrowser(_ url: String, routerDelegate: SystemBrowser, _ completionHandler: @escaping (SystemBrowser.ReturnType) -> Void) {
        routerDelegate.handleOpen(url, completionHandler)
    }
}
