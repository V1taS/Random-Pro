import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: appName,
  organizationName: organizationName,
  options: .options(automaticSchemesOptions: .disabled),
  settings: projectBuildIOSSettings,
  targets: [
    .target(
      name: appName,
      destinations: .iOS,
      product: .app,
      bundleId: "\(reverseOrganizationName).\(appName)",
      deploymentTargets: DeploymentTargets.iOS(iOSTargetVersion),
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
    .target(
      name: widgetName,
      destinations: .iOS,
      product: .appExtension,
      bundleId: "\(reverseOrganizationName).\(appName).\(widgetName)",
      deploymentTargets: DeploymentTargets.iOS("14.0"),
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
    .target(
       name: "\(appName)Tests",
       destinations: .iOS,
       product: .unitTests,
       bundleId: "\(reverseOrganizationName).\(appName)Tests",
       deploymentTargets: DeploymentTargets.iOS(iOSTargetVersion),
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
