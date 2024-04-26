// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RedisHelperLibrary",
    products: [
        .library(
            name: "RedisHelperLibrary",
            targets: ["RedisHelperLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Mordil/RediStack.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "RedisHelperLibrary",
            dependencies: [
                .product(name: "RediStack", package: "RediStack")
            ]),
    ]
)

