import UIKit

public enum OSIABViewStyle: String {
    case formSheet = "FORM_SHEET"
    case fullScreen = "FULL_SCREEN"
    case pageSheet = "PAGE_SHEET"
    
    public static let defaultValue: Self = .fullScreen
}

extension OSIABViewStyle {
    func toModalPresentationStyle() -> UIModalPresentationStyle {
        let result: UIModalPresentationStyle
        
        switch self {
        case .formSheet: result = .formSheet
        case .fullScreen: result = .fullScreen
        case .pageSheet: result = .pageSheet
        }
        
        return result
    }
}
