import SwiftUI

/// View that manages which view to present, depending if the page load was successful or not or is being loaded.
struct OSIABWebViewWrapperView: View {
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

@available(*, unavailable)
struct OSIABWebViewWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        // Default - Light Mode
        OSIABWebViewWrapperView(makeModel())

        // Default - Dark Mode
        OSIABWebViewWrapperView(makeModel())
            .preferredColorScheme(.dark)

        // Bottom Toolbar Defined
        OSIABWebViewWrapperView(makeModel(toolbarPosition: .bottom))

        // Error View - Light mode
        OSIABWebViewWrapperView(makeModel(url: "https://outsystems/"))

        // Error View - Dark mode
        OSIABWebViewWrapperView(makeModel(url: "https://outsystems/"))
            .preferredColorScheme(.dark)
    }
    
    private static func makeModel(url: String = "https://outsystems.com", toolbarPosition: OSIABToolbarPosition = .defaultValue) -> OSIABWebViewModel {
        let configurationModel = OSIABWebViewConfigurationModel()
        return .init(
            url: .init(string: url)!,
            webViewConfiguration: configurationModel.toWebViewConfiguration(),
            uiModel: .init(toolbarPosition: toolbarPosition),
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: { _ in },
                onBrowserPageNavigationCompleted: { _ in }
            )
        )
    }
}
