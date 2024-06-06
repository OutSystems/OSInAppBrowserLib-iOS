import WebKit

public class OSIABWebViewOptions: OSIABOptions {
    private let showURL: Bool
    private let showToolbar: Bool
    let clearCache: Bool
    let clearSessionCache: Bool
    private let mediaPlaybackRequiresUserAction: Bool
    let closeButtonText: String
    private let toolbarPosition: OSIABToolbarPosition
    private let leftToRight: Bool
    let allowOverScroll: Bool
    let enableViewportScale: Bool
    let allowInLineMediaPlayback: Bool
    let surpressIncrementalRendering: Bool
    
    public init(
        showURL: Bool = false,
        showToolbar: Bool = true,
        clearCache: Bool = true,
        clearSessionCache: Bool = true,
        mediaPlaybackRequiresUserAction: Bool = false,
        closeButtonText: String = "Close",
        toolbarPosition: OSIABToolbarPosition = .defaultValue,
        leftToRight: Bool = false,
        allowOverScroll: Bool = false,
        enableViewportScale: Bool = false,
        allowInLineMediaPlayback: Bool = false,
        surpressIncrementalRendering: Bool = false,
        viewStyle: OSIABViewStyle = .defaultValue, 
        animationEffect: OSIABAnimationEffect = .defaultValue
    ) {
        self.showURL = showURL
        self.showToolbar = showToolbar
        self.clearCache = clearCache
        self.clearSessionCache = clearSessionCache
        self.mediaPlaybackRequiresUserAction = mediaPlaybackRequiresUserAction
        self.closeButtonText = closeButtonText
        self.toolbarPosition = toolbarPosition
        self.leftToRight = leftToRight
        self.allowOverScroll = allowOverScroll
        self.enableViewportScale = enableViewportScale
        self.allowInLineMediaPlayback = allowInLineMediaPlayback
        self.surpressIncrementalRendering = surpressIncrementalRendering
        super.init(viewStyle: viewStyle, animationEffect: animationEffect)
    }
}

extension OSIABWebViewOptions {
    var mediaTypesRequiringUserActionForPlayback: WKAudiovisualMediaTypes {
        self.mediaPlaybackRequiresUserAction ? .all : []
    }
}
