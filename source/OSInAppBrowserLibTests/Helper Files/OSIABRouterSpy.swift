import OSInAppBrowserLib

struct OSIABRouterSpy: OSIABRouter {
    var shouldOpenSafari: Bool
    
    init(_ shouldOpenSafari: Bool) {
        self.shouldOpenSafari = shouldOpenSafari
    }
    
    func openInSafari(_ url: String) -> Bool { shouldOpenSafari }
}
