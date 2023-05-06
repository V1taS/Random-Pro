import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: appName,
  organizationName: organizationName,
  options: .options(automaticSchemesOptions: .disabled),
  settings: projectBuildIOSSettings,
  targets: [
    Target(
      name: appName,
      platform: .iOS,
      product: .app,
      bundleId: "\(reverseOrganizationName).\(appName)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
      infoPlist: getMainIOSInfoPlist(),
      sources: [
        "\(rootPath)/\(appPath)/Sources/**/*",
      ],
      resources: [
        "\(rootPath)/\(appPath)/Resources/**/*",
      ],
      entitlements: .relativeToRoot("\(rootPath)/\(appPath)/Entity/Random.entitlements"),
      scripts: [
        scriptSwiftLint
      ],
      dependencies: [
        .target(name: "\(widgetName)"),
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
    ),
    Target(
      name: widgetName,
      platform: .iOS,
      product: .appExtension,
      bundleId: "\(reverseOrganizationName).\(appName).\(widgetName)",
      deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone, .ipad]),
      infoPlist: getWidgetIOSInfoPlist(),
      sources: [
        "\(rootPath)/\(widgetPath)/\(widgetName)/Sources/**/*",
      ],
      resources: [
        "\(rootPath)/\(widgetPath)/\(widgetName)/Resources/**/*",
      ],
      scripts: [],
      dependencies: [],
      settings: targetWidgetIOSSettings
    )
  ],
  schemes: [mainIOSScheme, yesNoWidgetScheme]
)
