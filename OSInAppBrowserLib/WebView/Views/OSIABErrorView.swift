import SwiftUI

struct OSIABErrorView: View {
    
    private let error: Error
    private let reload: () -> Void
    
    init(_ error: Error, _ reload: @escaping () -> Void) {
        self.error = error
        self.reload = reload
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
                }).buttonStyle(.plain)
            }
            Spacer()
        }.padding(.top, 120)
        .environment(\.layoutDirection, .leftToRight)
    }
}

#Preview("Default - Error Light") {
    OSIABErrorView(
        NSError(domain: "Preview", code: NSURLErrorBadURL), {
            print("Clicked reload")
        }
    )
}
