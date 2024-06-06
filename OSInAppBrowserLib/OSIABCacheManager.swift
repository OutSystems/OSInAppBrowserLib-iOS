import WebKit

public protocol OSIABCacheManager {
    typealias CacheCompletion = () -> Void
    func clearCache(_ completionHandler: @escaping CacheCompletion)
    func clearSessionCache(_ completionHandler: @escaping CacheCompletion)
}

public extension OSIABCacheManager {
    func clearCache(_ completionHandler: @escaping CacheCompletion = {}) {
        self.clearCache(completionHandler)
    }
    
    func clearSessionCache(_ completionHandler: @escaping CacheCompletion = {}) {
        self.clearSessionCache(completionHandler)
    }
}

public struct OSIABBrowserCacheManager {
    let dataStore: WKWebsiteDataStore
    
    public init(_ dataStore: WKWebsiteDataStore) {
        self.dataStore = dataStore
    }
}

extension OSIABBrowserCacheManager: OSIABCacheManager {
    private func clearCache(sessionCookiesOnly isSessionCookie: Bool, _ completionHandler: @escaping CacheCompletion) {
        let cookieStore = self.dataStore.httpCookieStore
        
        func delete(_ cookieArray: [HTTPCookie], _ completionHandler: CacheCompletion) {
            guard let cookie = cookieArray.first else { return completionHandler() }
            cookieStore.delete(cookie)
            delete(Array(cookieArray.dropFirst()), completionHandler)
        }
        
        cookieStore.getAllCookies { cookies in
            delete(isSessionCookie ? cookies.filter({ $0.isSessionOnly }) : cookies, completionHandler)
        }
    }
    
    public func clearCache(_ completionHandler: @escaping CacheCompletion) {
        self.clearCache(sessionCookiesOnly: false, completionHandler)
    }
    
    public func clearSessionCache(_ completionHandler: @escaping CacheCompletion) {
        self.clearCache(sessionCookiesOnly: true, completionHandler)
    }
}
