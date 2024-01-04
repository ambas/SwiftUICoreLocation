// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUICoreLocation",
    platforms: [.iOS(.v17), .macOS(.v14)], 
    products: [
      // Products define the executables and libraries a package produces, making them visible to other packages.
      .library(
        name: "SwiftUICoreLocation",
        targets: ["SwiftUICoreLocation"])
    ],
    dependencies: [
            .package(url: "https://github.com/AsyncSwift/AsyncLocationKit", from: "1.6.4"),
        ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUICoreLocation",
            dependencies: ["AsyncLocationKit"]),
        .testTarget(
            name: "SwiftUICoreLocationTests",
            dependencies: ["SwiftUICoreLocation"]),
    ]
)
// AsyncLocationKit
