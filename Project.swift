import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: appName,
  organizationName: organizationName,
  settings: projectBuildIOSSettings,
  targets: [
    Target(
      name: appName,
      platform: .iOS,
      product: .app,
      bundleId: "\(reverseOrganizationName).\(appName)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: getMainIOSInfoPlist(),
      sources: [
        "\(appPath)/Sources/**/*",
      ],
      resources: [
        "\(appPath)/Resources/**/*",
      ],
      entitlements: .relativeToRoot("\(appPath)/Entity/Random.entitlements"),
      scripts: [
        scriptSwiftLint
      ],
      dependencies: [
        .external(name: "RandomUIKit"),
        .external(name: "RandomNetwork"),
        .external(name: "Notifications"),
        .external(name: "ApphudSDK"),
        .external(name: "KeychainSwift"),
        .external(name: "YandexMobileMetricaPush"),
        .external(name: "YandexMobileMetrica"),
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseAuth")
      ],
      settings: targetBuildIOSSettings
    )
  ],
  schemes: [mainIOSScheme]
)
