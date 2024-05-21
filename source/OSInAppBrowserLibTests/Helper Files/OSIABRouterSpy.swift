import OSInAppBrowserLib

class OSIABRouterSpy: OSIABRouter {
    var safariWasOpened: Bool = false
    var urlOpened: String = ""
    
    func openInSafari(_ url: String) {
        self.urlOpened = url
        self.safariWasOpened = true
    }
}
