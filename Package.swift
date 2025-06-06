// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AboutWindow",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AboutWindow",
            targets: ["AboutWindow"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/lukepistrol/SwiftLintPlugin",
            from: "0.2.2"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AboutWindow",
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]),
        .testTarget(
            name: "AboutWindowTests",
            dependencies: ["AboutWindow"]
        ),
    ]
)
