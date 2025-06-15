// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BearPublish",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/johnsundell/plot.git", from: "0.9.0"),
        .package(url: "https://github.com/objecthub/swift-markdownkit", from: "1.1.7"),
        .package(url: "https://github.com/stephencelis/SQLite.swift", branch: "master"),
    ],
    targets: [
        .target(name: "BearDomain"),
        .target(name: "BearPublish", dependencies: [
            "BearDomain",
            "BearWebUI",
            "BearDatabase",
            "BearMarkdown"
        ]),
        .target(
            name: "BearWebUI",
            dependencies: [.product(name: "Plot", package: "Plot")],
            resources: [.process("UI/Resources")]
        ),
        .target(name: "BearMarkdown", dependencies: [
            .product(name: "MarkdownKit", package: "swift-markdownkit")
        ]),
        .target(name: "BearDatabase", dependencies: [
            .product(name: "SQLite", package: "SQLite.swift")
        ]),
        .executableTarget(
            name: "BearPublishCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "BearPublish"
            ]
        ),
        .testTarget(
            name: "BearPublisherTests",
            dependencies: [
                "BearPublish",
                "BearPublishCLI",
                "BearMarkdown",
                "BearWebUI",
                "BearDatabase"],
            resources: [.process("database.sqlite")]
        )
    ]
)
