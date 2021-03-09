// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ISBN",
    platforms: [
        .macOS(.v10_10), .iOS(.v9), .tvOS(.v9)
    ],
    products: [
        .library(
            name: "ISBN",
            targets: ["ISBN"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ISBN",
            dependencies: []),
        .testTarget(
            name: "ISBNTests",
            dependencies: ["ISBN"]),
    ]
)
