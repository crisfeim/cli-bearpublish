// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BearPublisher",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/johnsundell/plot.git", from: "0.9.0"),
    ],
    targets: [
        .target(name: "BearPublisherWeb", dependencies: [
            .product(name: "Plot", package: "Plot"),
        ]),
        .executableTarget(
            name: "BearPublisherCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(name: "BearPublisherTests")
    ]
)
