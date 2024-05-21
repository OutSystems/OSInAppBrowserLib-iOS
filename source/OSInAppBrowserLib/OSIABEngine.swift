public struct OSIABEngine {
    private let router: OSIABRouter
    
    public init(router: OSIABRouter) {
        self.router = router
    }
    
    public func openExternalBrowser(_ url: String) -> Bool {
        self.router.openInSafari(url)
    }
}
