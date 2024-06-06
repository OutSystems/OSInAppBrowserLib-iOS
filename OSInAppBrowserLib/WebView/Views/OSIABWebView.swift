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
                Text(model.urlAddress)
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

//#Preview {
//    OSIABWebView(
//        .init(
//            url: .init(string: "https://outsystems.com")!,
//            callbackHandler: .init(onBrowserClosed: {})
//        )
//    )
//}
