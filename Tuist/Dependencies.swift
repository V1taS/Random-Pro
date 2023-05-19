import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
      .remote(url: "https://github.com/V1taS/RandomUIKit.git",
              requirement: .exact("1.8")),
      .remote(url: "https://github.com/V1taS/RandomNetwork.git",
              requirement: .exact("1.0")),
      .remote(url: "https://github.com/V1taS/Notifications",
              requirement: .exact("1.0")),
      .remote(url: "https://github.com/evgenyneu/keychain-swift.git",
              requirement: .branch("master")),
      
        .remote(url: "https://github.com/yandexmobile/metrica-sdk-ios",
                requirement: .upToNextMajor(from: "4.4.0")),
      .remote(url: "https://github.com/yandexmobile/metrica-push-sdk-ios",
              requirement: .upToNextMajor(from: "1.0.0")),
      .remote(url: "https://github.com/firebase/firebase-ios-sdk.git",
              requirement: .upToNextMajor(from: "9.0.0")),
      .remote(url: "https://github.com/apphud/ApphudSDK",
              requirement: .upToNextMajor(from: "2.0.0"))
    ]
  ),
  platforms: [.iOS]
)
