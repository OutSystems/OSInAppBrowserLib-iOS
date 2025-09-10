import XCTest
import SwiftUI
import ViewInspector
@testable import OSInAppBrowserLib

extension OSIABErrorView: Inspectable {}

final class OSIABErrorViewTests: XCTestCase {
    func testShowsErrorMessage() throws {
        let view = OSIABErrorView(
            NSError(domain: "Test", code: 1, userInfo: nil),
            reload: {},
            reloadViewLayoutDirection: .fixed(value: .leftToRight)
        )
        let vStack = try view.inspect().vStack()
        let text = try vStack.text(0).string()
        XCTAssertEqual(text, "Couldn't load the page content.")
    }

    func testReloadButtonAction() throws {
        var reloaded = false
        let view = OSIABErrorView(
            NSError(domain: "Test", code: 1, userInfo: nil),
            reload: { reloaded = true },
            reloadViewLayoutDirection: .fixed(value: .leftToRight)
        )
        let vStack = try view.inspect().vStack()
        let hStack = try vStack.hStack(1)
        let button = try hStack.button(0)
        try button.tap()
        XCTAssertTrue(reloaded)
    }

    func testReloadButtonLabel() throws {
        let view = OSIABErrorView(
            NSError(domain: "Test", code: 1, userInfo: nil),
            reload: {},
            reloadViewLayoutDirection: .fixed(value: .leftToRight)
        )
        let vStack = try view.inspect().vStack()
        let hStack = try vStack.hStack(1)
        let button = try hStack.button(0)
        let labelHStack = try button.labelView().hStack()
        let imageName = try labelHStack.image(0).actualImage().name()
        let text = try labelHStack.text(1).string()
        XCTAssertEqual(imageName, "arrow.clockwise")
        XCTAssertEqual(text, "Reload page")
    }
}
