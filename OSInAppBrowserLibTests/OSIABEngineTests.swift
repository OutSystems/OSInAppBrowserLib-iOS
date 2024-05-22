import OSInAppBrowserLib
import XCTest

final class OSIABEngineTests: XCTestCase {
    func test_open_externalBrowserWithoutIssues_doesOpenSafari() {
        let url = "https://www.outsystems.com/"
        XCTAssertTrue(self.makeSUT(shouldOpenSafari: true).openExternalBrowser(url))
    }
    
    func test_open_externalBrowserWithIssues_doesNotOpenSafari() {
        let url = "https://www.outsystems.com/"
        XCTAssertFalse(self.makeSUT(shouldOpenSafari: false).openExternalBrowser(url))
    }
}

private extension OSIABEngineTests {
    func makeSUT(shouldOpenSafari: Bool) -> OSIABEngine { OSIABEngine(router: OSIABRouterSpy(shouldOpenSafari)) }
}
