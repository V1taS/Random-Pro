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
      entitlements: .file(path: .relativeToRoot("\(rootPath)/\(appPath)/Entity/Random.entitlements")),
      scripts: [
        scriptSwiftLint
      ],
      dependencies: [
        .target(name: "\(widgetName)"),
        .external(name: "FancyUIKit"),
        .external(name: "FancyNetwork"),
        .external(name: "FancyNotifications"),
        .external(name: "ApphudSDK"),
        .external(name: "KeychainSwift"),
        .external(name: "YandexMobileMetricaPush"),
        .external(name: "YandexMobileMetrica"),
        .external(name: "RandomWheel")
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
      dependencies: [
        .external(name: "FancyUIKit")
      ],
      settings: targetWidgetIOSSettings
    ),
    Target(
       name: "\(appName)Tests",
       platform: .iOS,
       product: .unitTests,
       bundleId: "\(reverseOrganizationName).\(appName)Tests",
       deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone, .ipad]),
       infoPlist: .default,
       sources: [
        "\(rootPath)/\(appPath)/Tests/**/*"
       ],
       dependencies: [
        .target(name: "\(appName)"),
       ],
       settings: targetBuildTestsSettings
    )
  ],
  schemes: [mainIOSScheme, mainTestsIOSScheme, yesNoWidgetScheme]
)
