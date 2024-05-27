import SafariServices
import XCTest

@testable import OSInAppBrowserLib

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
    
    // MARK: Dismiss Style Tests
    
    func test_open_systemBrowserWithNoDismissStyle_doesOpenUsingDefaultDismissStyle() {
        let router = OSIABSafariViewControllerRouterAdapter()
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.dismissButtonStyle, OSIABDismissStyle.defaultValue.toSFSafariViewControllerDismissButtonStyle()
            )
        }
    }
    
    func test_open_systemBrowserWithDismissStyle_doesOpenUsingSpecifiedDismissStyle() {
        let router = OSIABSafariViewControllerRouterAdapter()
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router, dismissStyle: .close) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.dismissButtonStyle, OSIABDismissStyle.close.toSFSafariViewControllerDismissButtonStyle()
            )
        }
    }
    
    // MARK: View Style Tests
    
    func test_open_systemBrowserWithNoViewStyle_doesOpenUsingDefaultViewStyle() {
        let router = OSIABSafariViewControllerRouterAdapter()
        
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router) {
            XCTAssertEqual(
                $0?.modalPresentationStyle, OSIABViewStyle.defaultValue.toModalPresentationStyle()
            )
        }
    }
    
    func test_open_systemBrowserWithViewStyle_doesOpenUsingSpecifiedViewStyle() {
        let router = OSIABSafariViewControllerRouterAdapter()
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router, viewStyle: .pageSheet) {
            XCTAssertEqual(
                $0?.modalPresentationStyle, OSIABViewStyle.pageSheet.toModalPresentationStyle()
            )
        }
    }
    
    // MARK: Animation Tests
    
    func test_open_systemBrowserWithNoAnimation_doesOpenUsingDefaultAnimation() {
        let router = OSIABSafariViewControllerRouterAdapter()
        
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router) {
            XCTAssertEqual(
                $0?.modalTransitionStyle, OSIABAnimation.defaultValue.toModalTransitionStyle()
            )
        }
    }
    
    func test_open_systemBrowserWithAnimation_doesOpenUsingSpecifiedAnimation() {
        let router = OSIABSafariViewControllerRouterAdapter()
        
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router, animation: .flipHorizontal) {
            XCTAssertEqual(
                $0?.modalTransitionStyle, OSIABAnimation.flipHorizontal.toModalTransitionStyle()
            )
        }
    }
    
    // MARK: Enable Bars Collapsing Tests
    
    func test_open_systemBrowserWithNoEnableBarsCollapsingSet_doesOpenWithBarsCollapsing() {
        let router = OSIABSafariViewControllerRouterAdapter()
        
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.configuration.barCollapsingEnabled,
                true
            )
        }
    }
    
    func test_open_systemBrowserDisablingBarsCollapsing_doesOpenWithoutBarsCollapsing() {
        let router = OSIABSafariViewControllerRouterAdapter()
        
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router, enableBarsCollapsing: false) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.configuration.barCollapsingEnabled,
                false
            )
        }
    }
    
    // MARK: Enable Readers Mode Tests
    
    func test_open_systemBRowserWithNoEnableReadersModeSet_doesNotOpenInReadersMode() {
        let router = OSIABSafariViewControllerRouterAdapter()
        
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.configuration.entersReaderIfAvailable,
                false
            )
        }
    }
    
    func test_open_systemBrowserEnablingReadersMode_doesOpenInReadersMode() {
        let router = OSIABSafariViewControllerRouterAdapter()
        
        makeExternalRouterSpySUT().openSystemBrowser(url, routerDelegate: router, enableReadersMode: true) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.configuration.entersReaderIfAvailable,
                true
            )
        }
    }
}

extension OSIABEngineTests {
    func makeSUT() -> OSIABEngine<OSIABExternalRouterSpy, OSIABSystemRouterSpy> { .init() }
    func makeExternalRouterSpySUT() -> OSIABEngine<OSIABExternalRouterSpy, OSIABSafariViewControllerRouterAdapter> { .init() }
}
