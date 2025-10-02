// swift-tools-version: 6.0.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AboutWindow",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "AboutWindow",
            targets: ["AboutWindow"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AboutWindow"
        ),
        .testTarget(
            name: "AboutWindowTests",
            dependencies: ["AboutWindow"]
        ),
    ]
)
