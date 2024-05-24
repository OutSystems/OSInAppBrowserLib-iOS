import OSInAppBrowserLib
import UIKit

class OSApplicationStub: NSObject, OSIABApplicationDelegate {
    private let useValidURL: Bool
    private let ableToOpenURL: Bool
    
    init(_ useValidURL: Bool, _ ableToOpenURL: Bool) {
        self.useValidURL = useValidURL
        self.ableToOpenURL = ableToOpenURL
    }
    
    func canOpenURL(_ url: URL) -> Bool {
        return useValidURL
    }
    
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?) {
        completion?(ableToOpenURL)
    }
}
