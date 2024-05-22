/// The external browser router object, to be implemented by the objects who trigger the call.
public protocol OSIABRouter {
    /// Opens the passed `url` in the Safari app.
    /// - Parameter url: URL to be opened.
    /// - Returns: Indicates if the operation was successful or not.
    func openInSafari(_ url: String) -> Bool
}
