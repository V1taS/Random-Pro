// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SKUIKit",
  defaultLocalization: "en",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "SKUIKit",
      targets: ["SKUIKit"]
    ),
    .library(
      name: "FancyUIKit",
      targets: ["FancyUIKit"]
    )
  ],
  dependencies: [
    .package(path: "../../LocalDependencies/lottie-ios"),
    .package(path: "../../LocalDependencies/SKStyle"),
    .package(path: "../../LocalDependencies/SKAbstractions"),
    .package(path: "../../LocalDependencies/SKFoundation")
  ],
  targets: [
    .target(
      name: "SKUIKit",
      dependencies: [
        .product(name: "Lottie", package: "lottie-ios"),
        .product(name: "SKStyle", package: "SKStyle"),
        .product(name: "SKAbstractions", package: "SKAbstractions"),
        .product(name: "SKFoundation", package: "SKFoundation")
      ]
    ),
    .target(
      name: "FancyUIKit",
      dependencies: [
        .product(name: "Lottie", package: "lottie-ios"),
        .product(name: "FancyStyle", package: "SKStyle"),
        .product(name: "SKAbstractions", package: "SKAbstractions"),
        .product(name: "SKFoundation", package: "SKFoundation")
      ]
    )
  ]
)
