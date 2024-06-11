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
