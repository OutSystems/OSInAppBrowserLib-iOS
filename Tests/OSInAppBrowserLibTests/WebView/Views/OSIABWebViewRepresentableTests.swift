import XCTest
import WebKit
@testable import OSInAppBrowserLib

final class OSIABWebViewRepresentableTests: XCTestCase {
    
    func testInitializerStoresInjectedWebView() {
        let webView = WKWebView()
        let representable = OSIABWebViewRepresentable(webView)
        XCTAssertNotNil(representable)
    }
}
