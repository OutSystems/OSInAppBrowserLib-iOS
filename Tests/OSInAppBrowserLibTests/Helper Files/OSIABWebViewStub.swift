import WebKit

class OSIABNavigationActionStub: WKNavigationAction {
    var url: URL
    var mainDocumentURL: URL
    var useTargetFrame: Bool

    init(_ url: URL, mainDocumentURL: URL? = nil, useTargetFrame: Bool = false) {
        self.url = url
        self.mainDocumentURL = mainDocumentURL ?? url
        self.useTargetFrame = useTargetFrame
    }

    override var request: URLRequest {
        var result = URLRequest(url: self.url)
        result.mainDocumentURL = self.mainDocumentURL
        return result
    }

    override var targetFrame: WKFrameInfo? {
        self.useTargetFrame ? OSIABFrameInfoStub.shared : nil
    }

}

/// `WKFrameInfo` has no supported public initializer; WebKit expects every instance to come from
/// its own internal frame-tracking machinery. Deallocating a bare `WKFrameInfo()` crashes on some
/// WebKit versions (e.g. 26/27), so a single instance is created once here and deliberately kept
/// alive for the lifetime of the test process to avoid ever triggering that `dealloc` path.
enum OSIABFrameInfoStub {
    static let shared = WKFrameInfo()
}
