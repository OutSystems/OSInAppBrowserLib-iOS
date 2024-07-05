import SwiftUI

/// View that manages which view to present, depending if the page load was successful or not or is being loaded.
struct OSIABWebViewWrapper: View {
    /// View Model containing all the customisable elements.
    @StateObject private var model: OSIABWebViewModel
    
    /// Constructor method.
    /// - Parameter model: View Model containing all the customisable elements.
    init(_ model: OSIABWebViewModel) {
        self._model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        ZStack {
            OSIABWebView(model)
                .ignoresSafeArea(edges: model.toolbarPosition == .bottom ? [] : .bottom)
            if model.isLoading {
                ProgressView()
            }
        }
    }
}

// MARK: - OSIABViewModel's constructor accelerator.
private extension OSIABWebViewModel {
    convenience init(toolbarPosition: OSIABToolbarPosition = .defaultValue) {
        let configurationModel = OSIABWebViewConfigurationModel()
        self.init(
            url: .init(string: "https://outsystems.com")!,
            configurationModel.toWebViewConfiguration(),
            uiModel: .init(toolbarPosition: toolbarPosition),
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: { _ in }
            )
        )
    }
    
    convenience init(url: String) {
        let configurationModel = OSIABWebViewConfigurationModel()
        self.init(
            url: .init(string: url)!,
            configurationModel.toWebViewConfiguration(),
            uiModel: .init(),
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: { _ in }
            )
        )
    }
}

#Preview("Default - Light Mode") {
    OSIABWebViewWrapper(.init())
}

#Preview("Default - Dark Mode") {
    OSIABWebViewWrapper(.init())
        .preferredColorScheme(.dark)
}

#Preview("Bottom Toolbar Defined") {
    OSIABWebViewWrapper(.init(toolbarPosition: .bottom))
}

#Preview("Error View - Light mode") {
    OSIABWebViewWrapper(.init(url: "https://outsystems/"))
}

#Preview("Error View - Dark mode") {
    OSIABWebViewWrapper(.init(url: "https://outsystems/"))
        .preferredColorScheme(.dark)
}
