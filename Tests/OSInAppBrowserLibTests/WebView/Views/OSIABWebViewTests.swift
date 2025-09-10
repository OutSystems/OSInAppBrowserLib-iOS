import XCTest
import ViewInspector
@testable import OSInAppBrowserLib

final class OSIABWebViewTests: XCTestCase {
    func testToolbarAppearsAtTop() throws {
        let model = OSIABWebViewModel(
            url: URL(string: "https://test.com")!,
            webViewConfiguration: .init(),
            uiModel: .init(
                showURL: true,
                showToolbar: true,
                toolbarPosition: .top,
                showNavigationButtons: true,
                leftToRight: false,
                closeButtonText: "Close"
            ),
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: { _ in },
                onBrowserPageNavigationCompleted: { _ in }
            )
        )
        let view = OSIABWebView(model)
        let vStack = try view.inspect().vStack()
        // Toolbar should be the first element
        XCTAssertNoThrow(try vStack.hStack(0))
    }

    func testToolbarAppearsAtBottom() throws {
        let model = OSIABWebViewModel(
            url: URL(string: "https://test.com")!,
            webViewConfiguration: .init(),
            uiModel: .init(
                showURL: true,
                showToolbar: true,
                toolbarPosition: .bottom,
                showNavigationButtons: true,
                leftToRight: false,
                closeButtonText: "Close"
            ),
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: { _ in },
                onBrowserPageNavigationCompleted: { _ in }
            )
        )
        let view = OSIABWebView(model)
        let vStack = try view.inspect().vStack()
        // Toolbar should be the last element
        XCTAssertNoThrow(try vStack.view(OSIABNavigationView.self, 2))
    }

    func testErrorViewAppears() throws {
        let model = OSIABWebViewModel(
            url: URL(string: "https://test.com")!,
            webViewConfiguration: .init(),
            uiModel: .init(
                showURL: true,
                showToolbar: true,
                toolbarPosition: .top,
                showNavigationButtons: true,
                leftToRight: false,
                closeButtonText: "Close"
            ),
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: { _ in },
                onBrowserPageNavigationCompleted: { _ in }
            )
        )
        // Simulate error using test-only method
        model.setErrorForTesting(NSError(domain: "Test", code: 1, userInfo: nil))
        let view = OSIABWebView(model)
        let vStack = try view.inspect().vStack()
        // Error view should be present
        XCTAssertNoThrow(try vStack.view(OSIABErrorView.self, 1))
    }

    func testCloseButtonAction() throws {
        var closed = false
        let model = OSIABWebViewModel(
            url: URL(string: "https://test.com")!,
            webViewConfiguration: .init(),
            uiModel: .init(
                showURL: true,
                showToolbar: true,
                toolbarPosition: .top,
                showNavigationButtons: true,
                leftToRight: false,
                closeButtonText: "Close"
            ),
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: { _ in closed = true },
                onBrowserPageNavigationCompleted: { _ in }
            )
        )
        let view = OSIABWebView(model)
        let vStack = try view.inspect().vStack()
        let hStack = try vStack.hStack(0)
        // Find the button with label "Close"
        var found = false
        for idx in 0..<hStack.count {
            if let label = try? hStack.button(idx).labelView().text().string(), label == "Close" {
                try hStack.button(idx).tap()
                found = true
                break
            }
        }
        XCTAssertTrue(found, "Close button not found")
        XCTAssertTrue(closed)
    }

    func testLoadURLCalledOnAppear() throws {
        class TestModel: OSIABWebViewModel {
            var loadURLCalled = false
            override func loadURL() {
                super.loadURL()
                loadURLCalled = true
            }
        }
        let model = TestModel(
            url: URL(string: "https://test.com")!,
            webViewConfiguration: .init(),
            uiModel: .init(
                showURL: true,
                showToolbar: true,
                toolbarPosition: .top,
                showNavigationButtons: true,
                leftToRight: false,
                closeButtonText: "Close"
            ),
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: { _ in },
                onBrowserPageNavigationCompleted: { _ in }
            )
        )
        let view = OSIABWebView(model)
        let vStack = try view.inspect().vStack()
        _ = try vStack.callOnAppear()
        XCTAssertTrue(model.loadURLCalled)
    }
}
