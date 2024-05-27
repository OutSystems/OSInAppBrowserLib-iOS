import OSInAppBrowserLib
import SafariServices
import XCTest

final class OSIABSafariVCRouterAdapterTests: XCTestCase {
    func test_handleOpen_invalidURL_doesNotReturnViewController() {
        makeSUT().handleOpen("https://invalid url") { XCTAssertNil($0) }
    }
    
    func test_handleOpen_validURL_doesReturnSFSafariViewController() {
        makeSUT().handleOpen("http://outsystems.com") { XCTAssertNotNil($0) }
    }
}

private extension OSIABSafariVCRouterAdapterTests {
    func makeSUT() -> OSIABSafariViewControllerRouterAdapter { .init() }
}
