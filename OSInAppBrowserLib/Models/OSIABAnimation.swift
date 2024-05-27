import UIKit

public enum OSIABAnimation: String {
    case coverVertical = "COVER_VERTICAL"
    case crossDissolve = "CROSS_DISSOLVE"
    case flipHorizontal = "FLIP_HORIZONTAL"
    
    public static let defaultValue: Self = .coverVertical
}

extension OSIABAnimation {
    func toModalTransitionStyle() -> UIModalTransitionStyle {
        let result: UIModalTransitionStyle
        
        switch self {
        case .coverVertical: result = .coverVertical
        case .crossDissolve: result = .crossDissolve
        case .flipHorizontal: result = .flipHorizontal
        }
        
        return result
    }
}
