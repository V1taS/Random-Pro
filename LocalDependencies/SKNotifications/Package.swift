// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SKNotifications",
  defaultLocalization: "en",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "SKNotifications",
      targets: ["SKNotifications"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "SKNotifications",
      dependencies: []
    )
  ]
)
