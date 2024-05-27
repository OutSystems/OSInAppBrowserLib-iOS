import SafariServices

public enum OSIABDismissStyle: String {
    case cancel = "CANCEL"
    case close = "CLOSE"
    case done = "DONE"
    
    public static let defaultValue: Self = .done
}

extension OSIABDismissStyle {
    func toSFSafariViewControllerDismissButtonStyle() -> SFSafariViewController.DismissButtonStyle {
        let result: SFSafariViewController.DismissButtonStyle
        
        switch self {
        case .cancel: result = .cancel
        case .close: result = .close
        case .done: result = .done
        }
        
        return result
    }
}
