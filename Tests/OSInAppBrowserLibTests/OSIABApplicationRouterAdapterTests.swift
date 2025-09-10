import XCTest
@testable import OSInAppBrowserLib

class MockURLOpener: URLOpener {
    var canOpenURLCalled = false
    var openCalled = false

    var canOpenURLResult = true
    var lastOpenedURL: URL?
    var completionResult = true

    func canOpenURL(_ url: URL) -> Bool {
        canOpenURLCalled = true
        return canOpenURLResult
    }

    func open(_ url: URL, completionHandler: ((Bool) -> Void)?) {
        openCalled = true
        lastOpenedURL = url
        completionHandler?(completionResult)
    }
}

final class OSIABApplicationRouterAdapterTests: XCTestCase {
    
    func test_handleOpen_whenCanOpenURLIsFalse_shouldCallCompletionWithFalse() {
        let mock = MockURLOpener()
        mock.canOpenURLResult = false
        let sut = OSIABApplicationRouterAdapter(urlOpener: mock)
        
        let expectation = XCTestExpectation(description: "Completion called")
        
        sut.handleOpen(URL(string: "https://example.com")!) { success in
            XCTAssertFalse(success)
            XCTAssertTrue(mock.canOpenURLCalled)
            XCTAssertFalse(mock.openCalled)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
    
    func test_handleOpen_whenCanOpenURLIsTrue_shouldOpenURL() {
        let mock = MockURLOpener()
        mock.canOpenURLResult = true
        mock.completionResult = true
        let sut = OSIABApplicationRouterAdapter(urlOpener: mock)
        
        let url = URL(string: "https://example.com")!
        let expectation = XCTestExpectation(description: "Completion called")

        sut.handleOpen(url) { success in
            XCTAssertTrue(success)
            XCTAssertTrue(mock.canOpenURLCalled)
            XCTAssertTrue(mock.openCalled)
            XCTAssertEqual(mock.lastOpenedURL, url)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
