import UIKit

public protocol URLOpener {
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, completionHandler: ((Bool) -> Void)?)
}

public class DefaultURLOpener: URLOpener {
    public init() {}
    
    public func canOpenURL(_ url: URL) -> Bool {
        UIApplication.shared.canOpenURL(url)
    }
    
    public func open(_ url: URL, completionHandler: ((Bool) -> Void)?) {
        UIApplication.shared.open(url, completionHandler: completionHandler ?? { _ in })
    }
}

public class OSIABApplicationRouterAdapter: OSIABRouter {
    public typealias ReturnType = Bool

    private let urlOpener: URLOpener

    public init(urlOpener: URLOpener = DefaultURLOpener()) {
        self.urlOpener = urlOpener
    }

    public func handleOpen(_ url: URL, _ completionHandler: @escaping (ReturnType) -> Void) {
        guard urlOpener.canOpenURL(url) else {
            return completionHandler(false)
        }
        urlOpener.open(url, completionHandler: completionHandler)
    }
}
