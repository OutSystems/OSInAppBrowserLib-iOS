/// Structure responsible for managing all InAppBrowser interactions.
public struct OSIABEngine {
    /// Router that performs the external browser jump.
    private let router: OSIABRouter
    
    /// Constructor method.
    /// - Parameter router: Router that performs the external browser jump.
    public init(router: OSIABRouter) {
        self.router = router
    }
    
    /// Trigger the external browser to open the passed `url`.
    /// - Parameter url: URL to be opened.
    /// - Returns: Indicates if the operation was successful or not.
    public func openExternalBrowser(_ url: String) -> Bool {
        self.router.openInSafari(url)
    }
}
