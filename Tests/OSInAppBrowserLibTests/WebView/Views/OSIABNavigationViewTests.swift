import XCTest
import SwiftUI
import ViewInspector
@testable import OSInAppBrowserLib

extension OSIABNavigationView: Inspectable {}

final class OSIABNavigationViewTests: XCTestCase {
    func testNavigationButtonsAreVisibleWhenEnabled() throws {
        let view = OSIABNavigationView(
            showNavigationButtons: true,
            backButtonPressed: {},
            backButtonEnabled: true,
            forwardButtonPressed: {},
            forwardButtonEnabled: true,
            addressLabel: "Test URL",
            addressLabelAlignment: .trailing,
            buttonLayoutDirection: .fixed(value: .leftToRight)
        )
        let hStack = try view.inspect().hStack()
        XCTAssertNoThrow(try hStack.find(OSIABNavigationButton.self))
    }

    func testNavigationButtonsAreHiddenWhenDisabled() throws {
        let view = OSIABNavigationView(
            showNavigationButtons: false,
            backButtonPressed: {},
            backButtonEnabled: true,
            forwardButtonPressed: {},
            forwardButtonEnabled: true,
            addressLabel: "Test URL",
            addressLabelAlignment: .trailing,
            buttonLayoutDirection: .fixed(value: .leftToRight)
        )
        let hStack = try view.inspect().hStack()
        XCTAssertThrowsError(try hStack.find(OSIABNavigationButton.self))
    }

    func testBackButtonIsDisabled() throws {
        let view = OSIABNavigationView(
            showNavigationButtons: true,
            backButtonPressed: {},
            backButtonEnabled: false,
            forwardButtonPressed: {},
            forwardButtonEnabled: true,
            addressLabel: "Test URL",
            addressLabelAlignment: .trailing,
            buttonLayoutDirection: .fixed(value: .leftToRight)
        )
        let backButton = try view.inspect().findAll(OSIABNavigationButton.self)[0]
        let isDisabled = try backButton.actualView().isDisabled
        XCTAssertTrue(isDisabled)
    }

    func testForwardButtonIsDisabled() throws {
        let view = OSIABNavigationView(
            showNavigationButtons: true,
            backButtonPressed: {},
            backButtonEnabled: true,
            forwardButtonPressed: {},
            forwardButtonEnabled: false,
            addressLabel: "Test URL",
            addressLabelAlignment: .trailing,
            buttonLayoutDirection: .fixed(value: .leftToRight)
        )
        let forwardButton = try view.inspect().findAll(OSIABNavigationButton.self)[1]
        let isDisabled = try forwardButton.actualView().isDisabled
        XCTAssertTrue(isDisabled)
    }

    func testAddressLabelIsVisibleAndCorrect() throws {
        let label = "Test URL"
        let view = OSIABNavigationView(
            showNavigationButtons: false,
            backButtonPressed: {},
            backButtonEnabled: true,
            forwardButtonPressed: {},
            forwardButtonEnabled: true,
            addressLabel: label,
            addressLabelAlignment: .center,
            buttonLayoutDirection: .fixed(value: .leftToRight)
        )
        let text = try view.inspect().find(ViewType.Text.self).string()
        XCTAssertEqual(text, label)
    }

    func testBackButtonActionIsCalled() throws {
        let exp = expectation(description: "Back button pressed")
        let view = OSIABNavigationView(
            showNavigationButtons: true,
            backButtonPressed: { exp.fulfill() },
            backButtonEnabled: true,
            forwardButtonPressed: {},
            forwardButtonEnabled: true,
            addressLabel: "Test URL",
            addressLabelAlignment: .trailing,
            buttonLayoutDirection: .fixed(value: .leftToRight)
        )
        let backButton = try view.inspect().findAll(OSIABNavigationButton.self)[0]
        try backButton.button().tap()
        wait(for: [exp], timeout: 1)
    }

    func testForwardButtonActionIsCalled() throws {
        let exp = expectation(description: "Forward button pressed")
        let view = OSIABNavigationView(
            showNavigationButtons: true,
            backButtonPressed: {},
            backButtonEnabled: true,
            forwardButtonPressed: { exp.fulfill() },
            forwardButtonEnabled: true,
            addressLabel: "Test URL",
            addressLabelAlignment: .trailing,
            buttonLayoutDirection: .fixed(value: .leftToRight)
        )
        let forwardButton = try view.inspect().findAll(OSIABNavigationButton.self)[1]
        try forwardButton.button().tap()
        wait(for: [exp], timeout: 1)
    }
}
