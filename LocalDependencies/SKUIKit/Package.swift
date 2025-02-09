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
    .package(path: "../../LocalDependencies/SKStyle"),
    .package(path: "../../LocalDependencies/SKAbstractions"),
    .package(path: "../../LocalDependencies/SKFoundation"),
    .package(url: "https://github.com/airbnb/lottie-spm.git", exact: "4.5.1")
  ],
  targets: [
    .target(
      name: "SKUIKit",
      dependencies: [
        .product(name: "Lottie", package: "lottie-spm"),
        .product(name: "SKStyle", package: "SKStyle"),
        .product(name: "SKAbstractions", package: "SKAbstractions"),
        .product(name: "SKFoundation", package: "SKFoundation")
      ],
      resources: [.process("Resources")]
    ),
    .target(
      name: "FancyUIKit",
      dependencies: [
        .product(name: "Lottie", package: "lottie-spm"),
        .product(name: "FancyStyle", package: "SKStyle"),
        .product(name: "SKAbstractions", package: "SKAbstractions"),
        .product(name: "SKFoundation", package: "SKFoundation")
      ],
      resources: [.process("Resources")]
    )
  ]
)
