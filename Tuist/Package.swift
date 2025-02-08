// swift-tools-version: 5.6
//
//  Package.swift
//  ProjectDescriptionHelpers
//
//  Created by Vitalii Sosin on 04.03.2024.
//

import PackageDescription

let package = Package(
  name: "Package",
  dependencies: [
    .package(path: "../LocalDependencies/SKUIKit"),
    .package(path: "../LocalDependencies/SKServices"),

    .package(url: "https://github.com/V1taS/RandomWheel.git", exact: "1.4.0"),
    .package(url: "https://github.com/yandexmobile/metrica-sdk-ios", exact: "4.5.0"),
    .package(url: "https://github.com/yandexmobile/metrica-push-sdk-ios", exact: "1.3.0"),
    .package(url: "https://github.com/evgenyneu/keychain-swift.git", exact: "20.0.0"),
    .package(url: "https://github.com/V1taS/FancyNetwork.git", exact: "1.1.0"),
  ]
)
