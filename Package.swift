// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OctobusClient",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OctobusClient",
            targets: ["OctobusClient"]),
    ],
    dependencies: [
        .package(name: "Gzip", url: "https://github.com/1024jp/GzipSwift", from: "6.0.1"),
        .package(name: "Starscream", url: "https://github.com/daltoniam/Starscream", from: "4.0.4")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OctobusClient",
            dependencies: ["Gzip", "Starscream"]),
        .testTarget(
            name: "OctobusClientTests",
            dependencies: ["OctobusClient"]),
    ]
)
