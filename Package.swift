// swift-tools-version:6.2

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/03/2019.
//  All code (c) 2019 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import PackageDescription

let package = Package(
  name: "ISBN",

  platforms: [
    .macOS(.v15),
    .macCatalyst(.v18),
    .iOS(.v18),
    .tvOS(.v18),
    .watchOS(.v11),
    .custom("Ubuntu", versionString: "22.04"),
  ],

  products: [
    .library(
      name: "ISBN",
      targets: ["ISBN"]
    )
  ],

  targets: [
    .target(
      name: "ISBN"
    ),

    .testTarget(
      name: "ISBNTests",
      dependencies: ["ISBN"]
    ),
  ]
)
