import SwiftUI

/// View to use in case there was an error loading a URL on `OSIABWebView`.
/// It allows a reload operation to be performed.
struct OSIABErrorView: View {
    /// The error thrown.
    private let error: Error
    /// The reload operation to perform.
    private let reload: () -> Void
    /// Indicates if the how the reload view should be displayed in terms of layout.
    private let reloadViewLayoutDirection: OSIABLayoutDirectionEnum
    
    /// Constructor method.
    /// - Parameters:
    ///   - error: The error thrown.
    ///   - reload: The reload operation to perform.
    ///   - reloadViewLayoutDirection: Indicates if the how the reload view should be displayed in terms of layout.
    init(
        _ error: Error,
        _ reload: @escaping () -> Void,
        reloadViewLayoutDirection: OSIABLayoutDirectionEnum
    ) {
        self.error = error
        self.reload = reload
        self.reloadViewLayoutDirection = reloadViewLayoutDirection
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Couldn't load the page content.")
                .foregroundColor(.gray)
            HStack {
                Button(action: reload, label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Reload page").fontWeight(.semibold)
                    }
                    .layoutDirection(reloadViewLayoutDirection)
                })
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .padding(.top, 120)
        
    }
}

#Preview("Default - Error Light") {
    OSIABErrorView(
        NSError(domain: "Preview", code: NSURLErrorBadURL), 
        { print("Clicked reload") },
        reloadViewLayoutDirection: .fixed(value: .leftToRight)
    )
}
