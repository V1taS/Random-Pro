// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SKServices",
  defaultLocalization: "en",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "SKServices",
      targets: ["SKServices"]
    ),
  ],
  dependencies: [
    .package(path: "../../LocalDependencies/SKStyle"),
    .package(path: "../../LocalDependencies/SKAbstractions"),
    .package(path: "../../LocalDependencies/SKFoundation"),
    .package(path: "../../LocalDependencies/SKNotifications"),
    .package(url: "https://github.com/apphud/ApphudSDK", exact: "3.1.0"),
    .package(url: "https://github.com/amplitude/Amplitude-Swift", exact: "1.11.5"),
  ],
  targets: [
    .target(
      name: "SKServices",
      dependencies: [
        .product(name: "SKStyle", package: "SKStyle"),
        .product(name: "FancyStyle", package: "SKStyle"),
        "SKAbstractions",
        "SKFoundation",
        "SKNotifications",
        "ApphudSDK",
        .product(name: "AmplitudeSwift", package: "Amplitude-Swift")
      ]
    ),
    .testTarget(
      name: "SKServicesTests",
      dependencies: ["SKServices"]
    ),
  ]
)
