import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
      .remote(url: "https://github.com/V1taS/FancyUIKit.git",
              requirement: .exact("1.13")),
//      .local(path: "../Fancy/FancyUIKit"),
      .remote(url: "https://github.com/V1taS/FancyNetwork.git",
              requirement: .exact("1.1")),
      .remote(url: "https://github.com/V1taS/FancyNotifications.git",
              requirement: .exact("1.1")),
      .remote(url: "https://github.com/V1taS/RandomWheel.git",
              requirement: .exact("1.4")),
      
      .remote(url: "https://github.com/yandexmobile/metrica-sdk-ios",
              requirement: .exact("4.5.0")),
      .remote(url: "https://github.com/yandexmobile/metrica-push-sdk-ios",
              requirement: .exact("1.3.0")),
      
      .remote(url: "https://github.com/evgenyneu/keychain-swift.git",
              requirement: .exact("20.0.0")),
      .remote(url: "https://github.com/apphud/ApphudSDK",
              requirement: .exact("3.1.0")),
      
      .remote(url: "https://github.com/MAJKFL/Welcome-Sheet",
              requirement: .exact("1.2.0")),
    ]
  ),
  platforms: [.iOS]
)
