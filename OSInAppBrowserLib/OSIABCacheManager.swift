import WebKit

public protocol OSIABCacheManager {
    typealias CacheCompletion = () -> Void
    func clearCache(_ completionHandler: CacheCompletion?)
    func clearSessionCache(_ completionHandler: CacheCompletion?)
}

public extension OSIABCacheManager {
    func clearCache(_ completionHandler: CacheCompletion? = nil) {
        self.clearCache(completionHandler)
    }
    
    func clearSessionCache(_ completionHandler: CacheCompletion? = nil) {
        self.clearSessionCache(completionHandler)
    }
}

public struct OSIABBrowserCacheManager {
    let dataStore: WKWebsiteDataStore
    
    public init(dataStore: WKWebsiteDataStore) {
        self.dataStore = dataStore
    }
}

extension OSIABBrowserCacheManager: OSIABCacheManager {
    private func clearCache(sessionCookiesOnly isSessionCookie: Bool, _ completionHandler: CacheCompletion?) {
        let cookieStore = self.dataStore.httpCookieStore
        
        func delete(_ cookieArray: [HTTPCookie], _ completionHandler: CacheCompletion?) {
            guard let cookie = cookieArray.first else {
                completionHandler?()
                return
            }
            cookieStore.delete(cookie) {
                delete(Array(cookieArray.dropFirst()), completionHandler)
            }
        }
        
        cookieStore.getAllCookies { cookies in
            delete(isSessionCookie ? cookies.filter({ $0.isSessionOnly }) : cookies, completionHandler)
        }
    }
    
    public func clearCache(_ completionHandler: CacheCompletion?) {
        self.clearCache(sessionCookiesOnly: false, completionHandler)
    }
    
    public func clearSessionCache(_ completionHandler: CacheCompletion?) {
        self.clearCache(sessionCookiesOnly: true, completionHandler)
    }
}
