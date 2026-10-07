// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "OSInAppBrowserLib",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "OSInAppBrowserLib",
            targets: ["OSInAppBrowserLib"]
        ),
    ],
    targets: [
        .target(
            name: "OSInAppBrowserLib",
            path: "Sources/OSInAppBrowserLib"
        ),
        .testTarget(
            name: "OSInAppBrowserLibTests",
            dependencies: ["OSInAppBrowserLib"],
            path: "Tests/OSInAppBrowserLibTests"
        ),
    ]
)
