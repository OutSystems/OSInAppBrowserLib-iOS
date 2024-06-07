import SwiftUI

struct OSIABWebViewWrapper: View {
    @StateObject private var model: OSIABWebViewModel
    
    init(_ model: OSIABWebViewModel) {
        self._model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        ZStack {
            if let error = model.error {
                Text(error.localizedDescription)
                    .foregroundColor(.pink)
            } else {
                OSIABWebView(model)
                    .edgesIgnoringSafeArea(.bottom)
                if self.model.isLoading {
                    ProgressView()
                }
            }
        }
    }
}
