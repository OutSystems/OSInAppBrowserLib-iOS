import SafariServices

class OSSFSafariViewControllerStub: SFSafariViewController {
    let urlString: String
    
    init(_ urlString: String) {
        self.urlString = urlString
        super.init(url: URL(string: urlString)!)
    }
    
    override init(url URL: URL, configuration: SFSafariViewController.Configuration) {
        self.urlString = URL.absoluteString
        super.init(url: URL, configuration: configuration)
    }
}
