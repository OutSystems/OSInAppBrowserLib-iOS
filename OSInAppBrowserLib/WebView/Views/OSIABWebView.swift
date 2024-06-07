import SwiftUI

struct OSIABWebView: View {
    @ObservedObject private var model: OSIABWebViewModel
    
    init(_ model: OSIABWebViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: model.backButtonPressed, label: {
                    Image(systemName: "chevron.backward")
                })
                .disabled(!model.backButtonEnabled)
                Button(action: model.forwardButtonPressed, label: {
                    Image(systemName: "chevron.forward")
                })
                .disabled(!model.forwardButtonEnabled)
                
                Spacer()
                Text(model.addressLabel)
                    .lineLimit(1)
                    .allowsHitTesting(false)
                Spacer()
                
                Button(action: model.closeButtonPressed, label: {
                    Text(model.closeButtonText)
                })
            }
            .padding()
            OSIABWebViewRepresentable(model.webView)
        }
        .onAppear(perform: {
            model.loadURL()
        })
    }
}

private extension OSIABWebViewModel {
    convenience init(url: String, closeButtonText: String, onBrowserClosed: @escaping (Bool) -> Void) {
        self.init(
            url: .init(string: url)!,
            closeButtonText: closeButtonText,
            callbackHandler: .init(
                onDelegateURL: { _ in },
                onDelegateAlertController: { _ in },
                onBrowserPageLoad: {},
                onBrowserClosed: onBrowserClosed
            )
        )
    }
}

private struct OSIABTestWebView: View {
    @State var closeButtonCount = 0
    private let closeButtonText: String
    
    init(closeButtonText: String) {
        self.closeButtonText = closeButtonText
    }
    
    var body: some View {
        VStack {
            OSIABWebView(
                .init(
                    url: "https://outsystems.com",
                    closeButtonText: closeButtonText,
                    onBrowserClosed: { _ in closeButtonCount += 1 }
                )
            )
            Text("Close Button count: \(closeButtonCount)")
        }
    }
}

#Preview {
    OSIABTestWebView(closeButtonText: "Close")
}

#Preview {
    OSIABTestWebView(closeButtonText: "Open")
        .preferredColorScheme(.dark)
}
