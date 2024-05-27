import SafariServices

public struct OSIABSystemBrowserOptions {
    private(set) var dismissStyle: OSIABDismissStyle
    private(set) var viewStyle: OSIABViewStyle
    private(set) var animationEffect: OSIABAnimationEffect
    private(set) var enableBarsCollapsing: Bool
    private(set) var enableReadersMode: Bool
    
    public init(
        dismissStyle: OSIABDismissStyle = .defaultValue,
        viewStyle: OSIABViewStyle = .defaultValue,
        animationEffect: OSIABAnimationEffect = .defaultValue,
        enableBarsCollapsing: Bool = true, 
        enableReadersMode: Bool = false
    ) {
        self.dismissStyle = dismissStyle
        self.viewStyle = viewStyle
        self.animationEffect = animationEffect
        self.enableBarsCollapsing = enableBarsCollapsing
        self.enableReadersMode = enableReadersMode
    }
}

// MARK: - SFSafariViewController extensions
extension OSIABSystemBrowserOptions {
    var dismissButtonStyle: SFSafariViewController.DismissButtonStyle {
        self.dismissStyle.toSFSafariViewControllerDismissButtonStyle()
    }
    
    var modalPresentationStyle: UIModalPresentationStyle {
        self.viewStyle.toModalPresentationStyle()
    }
    
    var modalTransitionStyle: UIModalTransitionStyle {
        self.animationEffect.toModalTransitionStyle()
    }
}
