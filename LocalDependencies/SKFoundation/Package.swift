// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SKFoundation",
  defaultLocalization: "en",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "SKFoundation",
      targets: ["SKFoundation"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "SKFoundation",
      dependencies: []
    )
  ]
)
