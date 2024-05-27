/// The external browser router object, to be implemented by the objects who trigger the call.
public protocol OSIABRouter {
    associatedtype ReturnType
    /// Opens the passed `url` in the Safari app.
    /// - Parameter url: URL to be opened.
    /// - Returns: Indicates if the operation was successful or not.
    func handleOpen(_ url: String, dismissStyle: OSIABDismissStyle, viewStyle: OSIABViewStyle, animation: OSIABAnimation, enableBarsCollapsing: Bool, enableReadersMode: Bool, _ completionHandler: @escaping (ReturnType) -> Void)
}

public extension OSIABRouter {
    func handleOpen(_ url: String, dismissStyle: OSIABDismissStyle = .defaultValue, viewStyle: OSIABViewStyle = .defaultValue, animation: OSIABAnimation = .defaultValue, enableBarsCollapsing: Bool = true, enableReadersMode: Bool = false, _ completionHandler: @escaping (ReturnType) -> Void) {
        self.handleOpen(
            url, 
            dismissStyle: dismissStyle,
            viewStyle: viewStyle,
            animation: animation,
            enableBarsCollapsing: enableBarsCollapsing,
            enableReadersMode: enableReadersMode,
            completionHandler
        )
    }
}
