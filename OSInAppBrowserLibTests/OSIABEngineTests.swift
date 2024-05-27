import OSInAppBrowserLib
import SafariServices
import XCTest

final class OSIABEngineTests: XCTestCase {
    let url = "https://www.outsystems.com/"
    
    // MARK: - Open in External Browser Tests
    
    func test_open_externalBrowserWithoutIssues_doesOpen() {
        let routerSpy = OSIABExternalRouterSpy(shouldOpenSafari: true)
        makeSUT().openExternalBrowser(url, routerDelegate: routerSpy) { XCTAssertTrue($0) }
    }
    
    func test_open_externalBrowserWithIssues_doesNotOpen() {
        let routerSpy = OSIABExternalRouterSpy(shouldOpenSafari: false)
        makeSUT().openExternalBrowser(url, routerDelegate: routerSpy) { XCTAssertFalse($0) }
    }
    
    // MARK: - Open in System Browser Tests
    
    func test_open_systemBrowserWithoutIssues_doesOpen() {
        let routerSpy = OSIABSystemRouterSpy(shouldOpen: UIViewController())
        makeSUT().openSystemBrowser(url, routerDelegate: routerSpy) { XCTAssertNotNil($0) }
    }
    
    func test_open_systemBrowserWithIssues_doesNotOpen() {
        let routerSpy = OSIABSystemRouterSpy(shouldOpen: nil)
        makeSUT().openSystemBrowser(url, routerDelegate: routerSpy) { XCTAssertNil($0) }
    }
}

extension OSIABEngineTests {
    func makeSUT() -> OSIABEngine<OSIABExternalRouterSpy, OSIABSystemRouterSpy> { .init() }   
}
