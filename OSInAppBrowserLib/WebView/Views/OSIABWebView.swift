import SwiftUI

/// View that provides the customisable "browser" experience.
struct OSIABWebView: View {
    /// View Model containing all the customisable elements.
    @ObservedObject private var model: OSIABWebViewModel
    
    /// Constructor method.
    /// - Parameter model: View Model containing all the customisable elements.
    init(_ model: OSIABWebViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            if let toolbarPosition = model.toolbarPosition {
                HStack {
                    if toolbarPosition == .top {
                        OSIABNavigationView(
                            showNavigationButtons: model.showNavigationButtons,
                            backButtonPressed: model.backButtonPressed,
                            backButtonEnabled: model.backButtonEnabled,
                            forwardButtonPressed: model.forwardButtonPressed,
                            forwardButtonEnabled: model.forwardButtonEnabled,
                            addressLabel: model.addressLabel,
                            addressLabelAlignment: model.showNavigationButtons ? .center : .leading,
                            buttonLayoutDirection: .fixed(value: .leftToRight)  // we force 'back' to come always before 'forward'
                        )
                    }
                    Spacer()
                    
                    Button(action: model.closeButtonPressed, label: {
                        Text(model.closeButtonText)
                            .bold()
                    })
                    .buttonStyle(.plain)
                }
                .padding()
            }
            if let error = model.error {
                OSIABErrorView(
                    error, 
                    reload: model.loadURL,
                    reloadViewLayoutDirection: .fixed(value: .leftToRight)
                )
            } else {
                OSIABWebViewRepresentable(model.webView)
            }
            
            if model.toolbarPosition == .bottom {
                OSIABNavigationView(
                    showNavigationButtons: model.showNavigationButtons,
                    backButtonPressed: model.backButtonPressed,
                    backButtonEnabled: model.backButtonEnabled,
                    forwardButtonPressed: model.forwardButtonPressed,
                    forwardButtonEnabled: model.forwardButtonEnabled,
                    addressLabel: model.addressLabel,
                    addressLabelAlignment: model.showNavigationButtons ? .trailing : .center,
                    buttonLayoutDirection: .fixed(value: .leftToRight) // we force 'back' to come always before 'forward'
                )
                .padding()
            }
        }
        .onAppear(perform: {
            model.loadURL()
        })
        .layoutDirection(.leftToRightBasedOn(value: model.leftToRight))
    }
}

// MARK: - OSIABViewModel's constructor accelerator.
private extension OSIABWebViewModel {
    convenience init(
        url: String,
        showURL: Bool, 
        showToolbar: Bool,
        toolbarPosition: OSIABToolbarPosition,
        showNavigationButtons: Bool,
        leftToRight: Bool,
        closeButtonText: String,
        onBrowserClosed: @escaping (Bool) -> Void
    ) {
        let configurationModel = OSIABWebViewConfigurationModel()
        self.init(
            url: .init(string: url)!,
            configurationModel.toWebViewConfiguration(),
            uiModel: .init(
                showURL: showURL,
                showToolbar: showToolbar,
                toolbarPosition: toolbarPosition,
                showNavigationButtons: showNavigationButtons,
                leftToRight: leftToRight,
                closeButtonText: closeButtonText
            ),
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: onBrowserClosed
            )
        )
    }
}

// MARK: - Preview Helper View
private struct OSIABTestWebView: View {
    @State private var closeButtonCount = 0
    private let closeButtonText: String
    private let showURL: Bool
    private let showToolbar: Bool
    private let toolbarPosition: OSIABToolbarPosition
    private let showNavigationButtons: Bool
    private let leftToRight: Bool
    private let isError: Bool
    
    init(
        closeButtonText: String = "Close",
        showURL: Bool = true,
        showToolbar: Bool = true,
        toolbarPosition: OSIABToolbarPosition = .defaultValue,
        showNavigationButtons: Bool = true,
        leftToRight: Bool = false,
        isError: Bool = false
    ) {
        self.closeButtonText = closeButtonText
        self.showURL = showURL
        self.showToolbar = showToolbar
        self.toolbarPosition = toolbarPosition
        self.showNavigationButtons = showNavigationButtons
        self.leftToRight = leftToRight
        self.isError = isError
    }
    
    var body: some View {
        VStack {
            OSIABWebView(
                .init(
                    url: self.isError ?  "https://outsystems" : "https://outsystems.com",
                    showURL: showURL,
                    showToolbar: showToolbar,
                    toolbarPosition: toolbarPosition,
                    showNavigationButtons: showNavigationButtons,
                    leftToRight: leftToRight,
                    closeButtonText: closeButtonText,
                    onBrowserClosed: { _ in closeButtonCount += 1 }
                )
            )
            Text("Close Button count: \(closeButtonCount)")
        }
    }
}

// MARK: - Default Views

#Preview("Default - Light Mode") {
    OSIABTestWebView()
}

#Preview("Default - Dark Mode") {
    OSIABTestWebView()
        .preferredColorScheme(.dark)
}

#Preview("Error - Light Mode") {
    OSIABTestWebView(isError: true)
}

// MARK: - Custom Close Button View

#Preview("Custom Close Button Text") {
    OSIABTestWebView(
        closeButtonText: "Done"
    )
}

// MARK: - No Toolbar View

#Preview("No Toolbar") {
    OSIABTestWebView(
        showToolbar: false
    )
}

// MARK: - Custom Views

#Preview("No URL and No Navigation Buttons") {
    OSIABTestWebView(
        showURL: false, 
        showNavigationButtons: false
    )
}

#Preview("No URL, No Navigation Buttons and Left-to-Right") {
    OSIABTestWebView(
        showURL: false, 
        showNavigationButtons: false,
        leftToRight: true
    )
}

#Preview("No URL") {
    OSIABTestWebView(
        showURL: false
    )
}

#Preview("No URL and Left-To-Right") {
    OSIABTestWebView(
        showURL: false, 
        leftToRight: true
    )
}

#Preview("No URL, Bottom Toolbar and No Navigation Buttons") {
    OSIABTestWebView(
        showURL: false, 
        toolbarPosition: .bottom,
        showNavigationButtons: false
    )
}

#Preview("No URL, Bottom Toolbar, No Navigation Buttons and Left-to-Right") {
    OSIABTestWebView(
        showURL: false, 
        toolbarPosition: .bottom,
        showNavigationButtons: false, 
        leftToRight: true
    )
}

#Preview("No URL and Bottom Toolbar") {
    OSIABTestWebView(
        showURL: false,
        toolbarPosition: .bottom
    )
}

#Preview("No URL, Bottom Toolbar and Left-to-Right") {
    OSIABTestWebView(
        showURL: false,
        toolbarPosition: .bottom,
        leftToRight: true
    )
}

#Preview("No Navigation Buttons") {
    OSIABTestWebView(
        showNavigationButtons: false
    )
}

#Preview("No Navigation Buttons and Left-to-Right") {
    OSIABTestWebView(
        showNavigationButtons: false,
        leftToRight: true
    )
}

#Preview("Left-to-Right") {
    OSIABTestWebView(
        leftToRight: true
    )
}

#Preview("Bottom Toolbar and No Navigation Buttons") {
    OSIABTestWebView(
        toolbarPosition: .bottom, 
        showNavigationButtons: false
    )
}

#Preview("Bottom Toolbar, No Navigation Buttons and Left-to-Right") {
    OSIABTestWebView(
        toolbarPosition: .bottom,
        showNavigationButtons: false,
        leftToRight: true
    )
}

#Preview("Bottom Toolbar") {
    OSIABTestWebView(
        toolbarPosition: .bottom
    )
}

#Preview("Bottom Toolbar and Left-to-Right") {
    OSIABTestWebView(
        toolbarPosition: .bottom,
        leftToRight: true
    )
}
