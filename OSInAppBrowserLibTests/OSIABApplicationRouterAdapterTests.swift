import OSInAppBrowserLib
import XCTest

final class OSIABApplicationRouterAdapterTests: XCTestCase {
    let url = URL(string: "https://www.outsystems.com/")!
    
    func test_handleOpen_withInvalidURL_returnsFalse() {
        let sut = makeSUT(useValidURL: false)
        sut.handleOpen(url) { XCTAssertFalse($0) }
    }
    
    func test_handleOpen_withValidButNotAbleToOpenItL_returnsFalse() {
        let sut = makeSUT(useValidURL: true, ableToOpenURL: false)
        sut.handleOpen(url) { XCTAssertFalse($0) }
    }
    
    func test_handleOpen_withValidAndAbleToOpenItL_returnsTrue() {
        let sut = makeSUT(useValidURL: true, ableToOpenURL: true)
        sut.handleOpen(url) { XCTAssertTrue($0) }
    }
}

private extension OSIABApplicationRouterAdapterTests {
    func makeSUT(useValidURL: Bool, ableToOpenURL: Bool = false) -> OSIABApplicationRouterAdapter {
        return .init(OSApplicationStub(useValidURL, ableToOpenURL))
    }
}
