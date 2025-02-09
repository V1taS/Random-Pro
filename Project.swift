import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: appName,
  organizationName: organizationName,
  options: .options(automaticSchemesOptions: .disabled),
  packages: [
    .local(path: .relativeToRoot("LocalDependencies/SKUIKit")),
    .local(path: .relativeToRoot("LocalDependencies/SKServices"))
  ],
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
        .package(product: "SKUIKit"),
        .package(product: "FancyUIKit"),
        .package(product: "SKServices"),
        .external(name: "KeychainSwift"),
        .external(name: "RandomWheel"),
        .external(name: "FancyNetwork")
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
        .package(product: "SKUIKit"),
        .package(product: "FancyUIKit"),
        .package(product: "SKServices"),
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
