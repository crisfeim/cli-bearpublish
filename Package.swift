// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BearPublish",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/johnsundell/plot.git", from: "0.9.0"),
        .package(url: "https://github.com/johnfairh/RubyGateway", from: "5.4.0"),
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
            dependencies: [
                "BearDomain",
                .product(name: "Plot", package: "Plot"),
            ],
            resources: [.process("Resources")]
        ),
        .target(name: "BearMarkdown", dependencies: [
            .product(name: "RubyGateway", package: "rubygateway"),
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
