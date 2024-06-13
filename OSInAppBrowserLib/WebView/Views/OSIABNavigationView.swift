import SwiftUI

/// View related with displaying the Navigation items (buttons + URL address)
struct OSIABNavigationView: View {
    /// Indicates if the navigations should be displayed on the toolbar.
    private let showNavigationButtons: Bool
    /// Handler to trigger when the back button is pressed.
    private let backButtonPressed: () -> Void
    /// Indicates if the back button is available for pressing.
    private let backButtonEnabled: Bool
    /// Handler to trigger when the forward button is pressed.
    private let forwardButtonPressed: () -> Void
    /// Indicates if the forward button is available for pressing.
    private let forwardButtonEnabled: Bool
    /// The current adress label being displayed on the screen. Empty string indicates that the address will not be displayed.
    private let addressLabel: String
    /// Alignment to apply to the URL address.
    private let addressLabelAlignment: Alignment
    
    /// Constructor method.
    /// - Parameters:
    ///   - showNavigationButtons: Indicates if the navigations should be displayed on the toolbar.
    ///   - backButtonPressed: Handler to trigger when the back button is pressed.
    ///   - backButtonEnabled: Indicates if the back button is available for pressing.
    ///   - forwardButtonPressed: Handler to trigger when the forward button is pressed.
    ///   - forwardButtonEnabled: Indicates if the forward button is available for pressing.
    ///   - addressLabel: The current adress label being displayed on the screen. Empty string indicates that the address will not be displayed.
    ///   - addressLabelAlignment: Alignment to apply to the URL address.
    init(
        showNavigationButtons: Bool,
        backButtonPressed: @escaping () -> Void,
        backButtonEnabled: Bool,
        forwardButtonPressed: @escaping () -> Void,
        forwardButtonEnabled: Bool,
        addressLabel: String,
        addressLabelAlignment: Alignment
    ) {
        self.showNavigationButtons = showNavigationButtons
        self.backButtonPressed = backButtonPressed
        self.backButtonEnabled = backButtonEnabled
        self.forwardButtonPressed = forwardButtonPressed
        self.forwardButtonEnabled = forwardButtonEnabled
        self.addressLabel = addressLabel
        self.addressLabelAlignment = addressLabelAlignment
    }
    
    var body: some View {
        HStack {
            if showNavigationButtons {
                HStack {
                    Button(action: backButtonPressed, label: {
                        Image(systemName: "chevron.backward")
                    })
                    .disabled(!backButtonEnabled)
                    
                    Button(action: forwardButtonPressed, label: {
                        Image(systemName: "chevron.forward")
                    })
                    .disabled(!forwardButtonEnabled)
                }
                // we force 'back' to come always before 'forward'
                .environment(\.layoutDirection, .leftToRight)
                
                Spacer()
            }
            
            if !addressLabel.isEmpty {
                Text(addressLabel)
                    .lineLimit(1)
                    .allowsHitTesting(false)
                    .frame(maxWidth: .infinity, alignment: addressLabelAlignment)
            }
        }
    }
}

// MARK: - Preview Helper View
private struct OSIABTestNavigationView: View {
    @State private var buttonPressedText = "No Button Pressed."
    private let showNavigationButtons: Bool
    private let backButtonEnabled: Bool
    private let forwardButtonEnabled: Bool
    private let addressLabel: String = "URL Address"

    init(
        showNavigationButtons: Bool = true,
        backButtonEnabled: Bool = false,
        forwardButtonEnabled: Bool = false
    ) {
        self.showNavigationButtons = showNavigationButtons
        self.backButtonEnabled = backButtonEnabled
        self.forwardButtonEnabled = forwardButtonEnabled
    }
    
    var body: some View {
        VStack {
            OSIABNavigationView(
                showNavigationButtons: showNavigationButtons,
                backButtonPressed: {
                    buttonPressedText = "Back Button Pressed."
                },
                backButtonEnabled: backButtonEnabled,
                forwardButtonPressed: {
                    buttonPressedText = "Forward Button Pressed."
                },
                forwardButtonEnabled: forwardButtonEnabled,
                addressLabel: addressLabel,
                addressLabelAlignment: showNavigationButtons ? .trailing : .center
            )
            .padding()
            .background(Color.secondary.opacity(0.3))
            
            Spacer()
            Text(buttonPressedText)
            Spacer()
        }
    }
}

#Preview("Default - Light Mode") {
    OSIABTestNavigationView()
}

#Preview("Default - Dark Mode") {
    OSIABTestNavigationView()
        .preferredColorScheme(.dark)
}

#Preview("Show Navigation Buttons Disabled") {
    OSIABTestNavigationView(showNavigationButtons: false)
}

#Preview("Back Button Enabled") {
    OSIABTestNavigationView(backButtonEnabled: true)
}

#Preview("Forward Button Enabled") {
    OSIABTestNavigationView(forwardButtonEnabled: true)
}

#Preview("Both Buttons Enabled") {
    OSIABTestNavigationView(backButtonEnabled: true, forwardButtonEnabled: true)
}
