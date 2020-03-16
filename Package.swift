// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "ISBN",
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
