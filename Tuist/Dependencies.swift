import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
      .remote(url: "https://github.com/V1taS/RandomUIKit.git",
              requirement: .exact("1.14")),
      .remote(url: "https://github.com/V1taS/RandomNetwork.git",
              requirement: .exact("1.3")),
      .remote(url: "https://github.com/V1taS/Notifications",
              requirement: .exact("1.0")),
      
      .remote(url: "https://github.com/yandexmobile/metrica-sdk-ios",
              requirement: .exact("4.5.0")),
      .remote(url: "https://github.com/yandexmobile/metrica-push-sdk-ios",
              requirement: .exact("1.3.0")),
      
      .remote(url: "https://github.com/evgenyneu/keychain-swift.git",
              requirement: .exact("20.0.0")),
      .remote(url: "https://github.com/apphud/ApphudSDK",
              requirement: .exact("2.8.8")),
      
      .remote(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
              requirement: .exact("10.5.0")),
      .remote(url: "https://github.com/firebase/firebase-ios-sdk.git",
              requirement: .exact("10.10.0"))
    ]
  ),
  platforms: [.iOS]
)
