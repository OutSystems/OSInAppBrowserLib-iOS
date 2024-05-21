import OSInAppBrowserLib
import XCTest

final class OSIABEngineTests: XCTestCase {
    func test_open_externalBrowser_safariWasOpened() {
        let url = "https://www.outsystems.com/"
        let routerSpy = OSIABRouterSpy()
        let sut = OSIABEngine(router: routerSpy)
        sut.openExternalBrowser(url)
        
        XCTAssertTrue(routerSpy.safariWasOpened)
        XCTAssertEqual(routerSpy.urlOpened, url)
    }
}
