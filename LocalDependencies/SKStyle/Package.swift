// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "SKStyle",
  defaultLocalization: "en",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "SKStyle",
      targets: ["SKStyle"]
    ),
    .library(
      name: "FancyStyle",
      targets: ["FancyStyle"]
    )
  ],
  targets: [
    .target(
      name: "SKStyle",
      dependencies: [],
      resources: [.process("Resources")]
    ),
    .target(
      name: "FancyStyle",
      dependencies: []
    )
  ]
)
