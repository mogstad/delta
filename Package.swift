// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Delta",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Delta",
            targets: ["Delta"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick", from: "5.0.0"),
        .package(url: "https://github.com/Quick/Nimble", from: "10.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Delta",
            dependencies: []),
        .testTarget(
            name: "DeltaTests",
            dependencies: [
                "Delta",
                .product(name: "Quick", package: "quick"),
                .product(name: "Nimble", package: "nimble")
            ]),
    ]
)
