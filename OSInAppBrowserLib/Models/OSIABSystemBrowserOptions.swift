import SafariServices

/// Structure that holds the value that a SystemBrowser (especifically `OSIABSafariViewControllerRouterAdapter`) can use for its visual presentation.
public struct OSIABSystemBrowserOptions {
    /// The dismiss style to present.
    private var dismissStyle: OSIABDismissStyle
    /// The view style to present.
    private var viewStyle: OSIABViewStyle
    /// The animation effect for the presentation appearance and dismissal.
    private var animationEffect: OSIABAnimationEffect
    /// Indicates if the bars should collapse when scrolling.
    private(set) var enableBarsCollapsing: Bool
    /// Indicates if the readers mode should be enabled if present.
    private(set) var enableReadersMode: Bool
    
    /// Constructor method.
    /// - Parameters:
    ///   - dismissStyle: The dismiss style to present. `defaultValue` is provided in case of no value.
    ///   - viewStyle: The view style to present. `defaultValue` is provided in case of no value.
    ///   - animationEffect: The animation effect for the presentation appearance and dismissal. `defaultValue` is provided in case of no value.
    ///   - enableBarsCollapsing: Indicates if the bars should collapse when scrolling. `true` is provided in case of no value.
    ///   - enableReadersMode: Indicates if the readers mode should be enabled if present. `false` is provided in case of no value.
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
    /// The `SFSafariViewController`'s `dismissStyle` equivalent value.
    var dismissButtonStyle: SFSafariViewController.DismissButtonStyle {
        self.dismissStyle.toSFSafariViewControllerDismissButtonStyle()
    }
    /// The `SFSafariViewController`'s `modalPresentationStyle` equivalent value.
    var modalPresentationStyle: UIModalPresentationStyle {
        self.viewStyle.toModalPresentationStyle()
    }
    /// The `SFSafariViewController`'s `modalTransitionStyle` equivalent value.
    var modalTransitionStyle: UIModalTransitionStyle {
        self.animationEffect.toModalTransitionStyle()
    }
}
