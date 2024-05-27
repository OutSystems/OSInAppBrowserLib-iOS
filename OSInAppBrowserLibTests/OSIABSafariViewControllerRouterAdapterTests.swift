import SafariServices
import XCTest

@testable import OSInAppBrowserLib

final class OSIABSafariVCRouterAdapterTests: XCTestCase {
    let validURL = "http://outsystems.com"
    
    func test_handleOpen_invalidURL_doesNotReturnViewController() {
        makeSUT().handleOpen("https://invalid url") { XCTAssertNil($0) }
    }
    
    func test_handleOpen_validURL_doesReturnSFSafariViewController() {
        makeSUT().handleOpen(validURL) { XCTAssertNotNil($0) }
    }
    
    // MARK: Dismiss Style Tests
    
    func test_handleOpen_noDismissStyle_doesReturnWithDefaultDismissStyle() {
        makeSUT().handleOpen(validURL) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.dismissButtonStyle, OSIABDismissStyle.defaultValue.toSFSafariViewControllerDismissButtonStyle()
            )
        }
    }
    
    func test_handleOpen_withDismissStyle_doesReturnWithSpecifiedDismissStyle() {
        let options = OSIABSystemBrowserOptions.init(dismissStyle: .close)
        makeSUT().handleOpen(validURL, options) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.dismissButtonStyle, OSIABDismissStyle.close.toSFSafariViewControllerDismissButtonStyle()
            )
        }
    }

    // MARK: View Style Tests
    
    func test_handleOpen_noViewStyle_doesReturnWithDefaultViewStyle() {
        makeSUT().handleOpen(validURL) {
            XCTAssertEqual(
                $0?.modalPresentationStyle, OSIABViewStyle.defaultValue.toModalPresentationStyle()
            )
        }
    }
    
    func test_handleOpen_withViewStyle_doesReturnWithSpecifiedViewStyle() {
        let options = OSIABSystemBrowserOptions.init(viewStyle: .pageSheet)
        makeSUT().handleOpen(validURL, options) {
            XCTAssertEqual(
                $0?.modalPresentationStyle, OSIABViewStyle.pageSheet.toModalPresentationStyle()
            )
        }
    }
 
    // MARK: Animation Effect Tests
    
    func test_handleOpen_noAnimationEffect_doesReturnWithDefaultAnimationEffect() {
        makeSUT().handleOpen(validURL) {
            XCTAssertEqual(
                $0?.modalTransitionStyle, OSIABAnimationEffect.defaultValue.toModalTransitionStyle()
            )
        }
    }
    
    func test_handleOpen_withAnimationEffect_doesReturnWithSpecifiedAnimationEffect() {
        let options = OSIABSystemBrowserOptions.init(animationEffect: .flipHorizontal)
        makeSUT().handleOpen(validURL, options) {
            XCTAssertEqual(
                $0?.modalTransitionStyle, OSIABAnimationEffect.flipHorizontal.toModalTransitionStyle()
            )
        }
    }
       
    // MARK: Enable Bars Collapsing Tests
    
    func test_handleOpen_noEnableBarsCollapsingSet_doesReturnWithBarsCollapsing() {
        makeSUT().handleOpen(validURL) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.configuration.barCollapsingEnabled, true
            )
        }
    }
    
    func test_handleOpen_disableBarsCollapsing_doesReturnWithoutBarsCollapsing() {
        let options = OSIABSystemBrowserOptions.init(enableBarsCollapsing: false)
        makeSUT().handleOpen(validURL, options) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.configuration.barCollapsingEnabled, false
            )
        }
    }

    // MARK: Enable Readers Mode Tests
    
    func test_handleOpen_noEnableReadersModeSet_doesReturnWithReadersModeDisabled() {
        makeSUT().handleOpen(validURL) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.configuration.entersReaderIfAvailable, false
            )
        }
    }
    
    func test_handleOpen_enableReadersMode_doesReturnWithReadersModeEnabled() {
        let options = OSIABSystemBrowserOptions.init(enableReadersMode: true)
        makeSUT().handleOpen(validURL, options) {
            XCTAssertEqual(
                ($0 as? SFSafariViewController)?.configuration.entersReaderIfAvailable, true
            )
        }
    }
}

private extension OSIABSafariVCRouterAdapterTests {
    func makeSUT() -> OSIABSafariViewControllerRouterAdapter { .init() }
}
