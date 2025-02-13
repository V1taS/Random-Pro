// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SKAbstractions",
  defaultLocalization: "en",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "SKAbstractions",
      targets: ["SKAbstractions"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "SKAbstractions",
      dependencies: [],
      resources: [.process("Resources")]
    )
  ]
)
